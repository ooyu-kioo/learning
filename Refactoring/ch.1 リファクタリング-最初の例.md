リファクタの感覚を掴むために、まず具体例から見ていく

- ex:劇団員を派遣して演劇を行う会社
  - 上映した演劇に応じて会社が請求を行う
  - 演劇は２種類：喜劇(30000USD)・悲劇(40000USD)
  - 席数(audience)に応じて次回以降の割引ポイントあり

```json
// 演目に関するデータ
// plays.json
{
  "hamlet": {"name": "Hamlet", "type": "tragedy"},
  "as−like": {"name": "As You Like It", "type": "comedy"},
  "othello": {"name": "Othello", "type": "tragedy"} }

// 請求に関するデータ
// invoices.json
[
  {
    "customer": "BigCo",
    "performances":[
      {"playID": "hamlet","audience": 55},
      {"playID": "as−like","audience": 35},
      {"playID": "othello","audience": 40}
    ]
  }
]
```
請求書を印刷するコード
```js
function statement(invoice, plays) {
  let totalAmount = 0;
  let volumeCredits = 0;
  let result = `Statement for ${invoice.customer}\n`;

  const format = new Intl.NumberFormat(
    "en−US",
    { style: "currency",
      currency: "USD",
      minimumFractionDigits: 2
    }
  ).format;
  
  for (let perf of invoice.performances) {
    const play = plays[perf.playID];
    let thisAmount = 0;
    
    switch(play.type) {
      case "tragedy":
        thisAmount = 40000;
        if (perf.audience > 30) {
          thisAmount += 1000 * (perf.audience − 30);
        }
        break;
      case "comedy":
        thisAmount = 30000;
        if (perf.audience > 20) {
          thisAmount += 10000 + 500 * (perf.audience − 20);
        }
        thisAmount += 300 * perf.audience;
        break;
      default:
        throw new Error(`unknown type: ${play.type}`);
    }
    
    // ボリューム特典のポイントを加算
    volumeCredits += Math.max(perf.audience − 30, 0);
    // 喜劇のときは10人につき、さらにポイントを加算
    volumeCredits += Math.floor(perf.audience / 5) if ("comedy" === play.type);
    // 注文の内訳を出力
    result += `  ${play.name}: ${format(thisAmount/100)} (${perf.audience} seats)\n`;
    totalAmount += thisAmount;
  }
  result += `Amount owed is ${format(totalAmount/100)}\n`;
  result += `You earned ${volumeCredits} credits\n`;
  return result;
}
```
- 極力ローカル変数(一時変数)は消していく
  - methodの抽出が楽になる
  - scope内部のみで有効 => 複雑なものになりやすい
  - 抽出したものをscopeで複数回呼び出すのは問題になりにくい

関数のまとまりが大きいので、小さな単位に抽出していく
- 手順
  - roopの分離 => 値の集計処理を分離する
  - statementのスライド => 初期化処理を各roopとまとめる
  - 関数の抽出
  - 変数のインライン化 => 不要なローカル変数を削除

```js
function statement(invoice, plays) {
  let result = `Statement for ${invoice.customer}\n`;
  for (let perf of invoice.performances) {
    result += `  ${playFor(perf).name}: ${usd(amountFor(perf))} (${perf.audience} seats)\n`;
  }
  result += `Amount owed is ${usd(totalAmount())}\n`;
  result += `You earned ${totalVolumeCredits()} credits\n`;
  return result;

  function totalAmount() {
    let result = 0;
    for (let perf of invoice.performances) {
      result += amountFor(perf);
    }
    return result;
  }

  function totalVolumeCredits() {
    let result = 0;
    for (let perf of invoice.performances) {
      result += volumeCreditsFor(perf);
    }
    return result;
  }

  function usd(aNumber) {
    return new Intl.NumberFormat(
      "en−US",
      { style: "currency",
        currency: "USD",
        minimumFractionDigits: 2
      }
    ).format(aNumber/100);
  }

  function volumeCreditsFor(aPerformance) {
    let result = 0;
    result += Math.max(aPerformance.audience - 30, 0);
    result += Math.floor(aPerformance.audience / 5) if ("comedy" === playFor(aPerformance).type);
    return result;
  }

  function playFor(aPerformance) {
    return plays[aPerformance.playID];
  }

  function amountFor(aPerformance) {
    let result = 0;
    switch (playFor(aPerformance).type) {
      case "tragedy":
        result = 40000;
        if (aPerformance.audience > 30) {
          result += 1000 * (aPerformance.audience - 30);
        }
        break;
      case "comedy":
        result = 30000;
        if (aPerformance.audience > 20) {
          result += 10000 + 500 * (aPerformance.audience - 20);
        }
        result += 300 * aPerformance.audience;
        break;
      default:
        throw new Error(`unknown type: ${playFor(aPerformance).type}`); 
    }
    return result;
  }
}
```

次に機能の変更(htmlフォーマットでの出力)
- 全体の処理を２つのフェーズに分ける
  - 請求書出力のための計算
  - フォーマットに応じた出力
- method間で受け渡すための中間データを作る
- invoice, playsのデータをそこに集約する

```js
// statement.js(請求書のフォーマット作成)
import createStatementData from './createStatementData.js'

function statement(invoice, plays) {
  return renderPlainText(createStatementData(invoice, plays))
}

function renderPlainText(data) {
  // ...
}

function htmlStatement(invoice, plays) {
  return renderHtml(createStatementData(invoice, plays))
}

function renderHtml(data) {
  // ...
}

function usd(aNumber) {
  return new Intl.NumberFormat(
    "en−US",
    {
      style: "currency",
      currency: "USD",
      minimumFractionDigits: 2
    }
  ).format(aNumber / 100);
}

// createStatementData.js(請求書の計算処理)
export default function createStatementData(invoice, plays) {
  const result = {};
  result.customer = invoice.customer;
  result.performances = invoice.performances.map(enrichPerformance);
  result.totalAmount = totalAmount(result);
  result.totalVolumeCredits = totalVolumeCredits(result);
  return result

  function enrichPerformance(aPerformance) {
    // 公演ごとに中間データの作成・値の設定
    const result = Object.assign({}, aPerformance) // 元のobjをコピー
    result.play = playFor(result);
    result.amount = amountFor(result);
    result.volumeCredits = volumeCreditsFor(result);
    return result;
  }

  function playFor(aPerformance) {
    return plays[aPerformance.playID];
  }

  function amountFor(aPerformance) {
    let result = 0;
    switch (aPerformance.play.type) {
      case "tragedy":
        result = 40000;
        if (aPerformance.audience > 30) {
          result += 1000 * (aPerformance.audience - 30);
        }
        break;
      case "comedy":
        result = 30000;
        if (aPerformance.audience > 20) {
          result += 10000 + 500 * (aPerformance.audience - 20);
        }
        result += 300 * aPerformance.audience;
        break;
      default:
        throw new Error(`unknown type: ${aPerformance.play.type}`);
    }
    return result;
  }

  function volumeCreditsFor(aPerformance) {
    let result = 0;
    result += Math.max(aPerformance.audience - 30, 0);
    result += Math.floor(aPerformance.audience / 5) if ("comedy" === aPerformance.play.type);
    return result;
  }

  function totalAmount(data) {
    let result = 0;
    for (let perf of data.performances) {
      result += perf.amount;
    }
    return result;
  }

  function totalVolumeCredits(data) {
    let result = 0;
    for (let perf of data.performances) {
      result += perf.volumeCreditsFor;
    }
    return result;
  }
}
```

次は新たな機能追加をしてみる
- 演劇の種類を増やしたい
- それぞれで異なる料金・ボリューム(割引)ポイントを設定したい

- 変更
  - 計算を行なっている関数内の処理を変える必要がある
  - 継承により喜劇・悲劇のサブクラスがそれぞれの計算ロジックを持つ
  - = enrichPerformanceでの各関数の呼び出しを、classのmethod呼び出しに変える必要がある

```js
// statement.js(請求書のフォーマット作成)
import createStatementData from './createStatementData.js'

function statement(invoice, plays) {
  return renderPlainText(createStatementData(invoice, plays))
}

function renderPlainText(data) {
  // ...
}

function htmlStatement(invoice, plays) {
  return renderHtml(createStatementData(invoice, plays))
}

function renderHtml(data) {
  // ...
}

function usd(aNumber) {
  return new Intl.NumberFormat(
    "en−US",
    {
      style: "currency",
      currency: "USD",
      minimumFractionDigits: 2
    }
  ).format(aNumber / 100);
}

function createPerformanceCalculator(aPerformance, aPlay) {
  switch (aPlay.type) {
    case "tragedy": return new TragedyCaluclator(aPerformance, aPlay)
    case "comedy": return new ComedyCaluculator(aPerformance, aPlay)
    default: throw new Error('道の演劇: ${aPlay.type}')
  }
}

class PerformanceCalculator {
  constructor(aPerformance, aPlay) {
    this.performance = aPerformance
    this.play = aPlay
  }

  // getter
  get amount() {
    throw new Error('サブクラスの責務だよー')
  }

  // ほとんど30が任意上でポイント適用するケースなので、必要に応じてsubでoverrideする
  get volumeCredits() {
    return Math.max(this.performances.audience - 30, 0);
  }
}

class TragedyCalculator extends PerformanceCalculator {
  get amount() {
    let result = 40000;
    if (this.performances.audience > 30) {
      result += 10000 * (this.performances.audience - 30);
    }
    return result;
  }
}

class ComedyCalculator extends PerformanceCalculator {
  get amount() {
    let result = 30000;
    if (this.performances.audience > 20) {
      result += 10000 + 500 * (this.performances.audience - 20);
    }
    result += 300 * this.performances.audience;
    return result;
  }

  get volumeCredits() {
    return super.volumeCredits + Math.floor(this.performances.audience / 5);
  }
}


// ***


// createStatementData.js(請求書の計算処理)
export default function createStatementData(invoice, plays) {
  const result = {};
  result.customer = invoice.customer;
  result.performances = invoice.performances.map(enrichPerformance);
  result.totalAmount = totalAmount(result);
  result.totalVolumeCredits = totalVolumeCredits(result);
  return result

  function enrichPerformance(aPerformance) {
    // 公演ごとに中間データの作成・値の設定
    const calculator = createPerformanceCalculator(aPerformance, playFor(aPerformance))
    const result = Object.assign({}, aPerformance) // 元のobjをコピー
    result.play = calculator.play;
    result.amount = calculator.amount;
    result.volumeCredits = calculator.volumeCredits;
    return result;
  }

  function playFor(aPerformance) {
    return plays[aPerformance.playID];
  }

  function totalAmount(data) {
    let result = 0;
    for (let perf of data.performances) {
      result += perf.amount;
    }
    return result;
  }

  function totalVolumeCredits(data) {
    let result = 0;
    for (let perf of data.performances) {
      result += perf.volumeCreditsFor;
    }
    return result;
  }
}
```