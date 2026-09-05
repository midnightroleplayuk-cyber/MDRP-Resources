if (Lang == undefined) {
    var Lang = [];
}
Lang["ja"] = {
    pumpInterface: {
        stationStock: "{0} L",
        vehicleFuel: "{0} L",
        confirm: "確認",
        vehicleFuelTooltip: "現在の燃料 / タンク容量",
        fuelTypes: {
            regular: "レギュラー",
            plus: "プラス",
            premium: "プレミアム",
            diesel: "ディーゼル",
        },
    },
    pumpRefuelDisplay: {
        liters: "L",
        carTank: "自動車タンク",
        remaining: "残り",
    },
    confirmRefuelModal: {
        title: "給油の確認",
        description: "{0}Lの{1}を{2}で購入します。",
        paymentBank: "銀行で支払う",
        paymentCash: "現金で支払う",
    },
    confirmBuyJerryCanModal: {
        title: "購入を確認する",
        paymentBank: "銀行で支払う",
        paymentCash: "現金で支払う",
    },
    confirmFuelChangeModal: {
        title: "燃料の混合はできません",
        description: "⚠️ 燃料の種類を変更する場合はタンクを空にしてください。",
    },
    electricInterface: {
        chargerType: {
            title: "チャージャータイプ",
            fast: {
                title: "高速",
                power: "220kW",
            },
            normal: {
                title: "普通",
                power: "100kW",
            },
            pricePerKWh: "{0}/kWh",
        },
        chargerAmount: {
            title: "金額選択",
            typeSelected: "{0}チャージャー",
            placeholder: "金額",
            timeToRechargeText: "充電時間:",
            timeToRechargeValue: "{0} 分 {1} 秒",
        },
        chargerPayment: {
            title: "支払い方法",
            money: "現金",
            bank: "銀行",
            payButton: "{0}で支払う",
        },
        continueButton: "決定",
        outOfStock: "在庫切れ",
    },
    rechargerDisplay: {
        title: "充電中・・・",
        remainingTimeText: "残り時間",
        remainingTimeValue: "{0} 分 {1} 秒",
    },
    fuelConsumptionChart: {
        title: "燃料消費チャート",
        chartLabels: {
            fuel: "燃料 (%)",
            speed: "速度 (km/h)",
            consumption: "消費量 (L/s)",
            shortSeconds: "{0}秒",
        },
        footer: {
            focus: "F3でフォーカス切替",
            toggleRecording: "記録の切り替え",
            recordsLength: "履歴の長さ ({0}秒)",
        },
    },
};