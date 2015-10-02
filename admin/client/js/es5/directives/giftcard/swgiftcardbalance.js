var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWGiftCardBalanceController = (function () {
        function SWGiftCardBalanceController($slatwall) {
            var _this = this;
            this.$slatwall = $slatwall;
            this.init = function () {
                _this.initialBalance = 0;
                var totalDebit = 0;
                var transactionConfig = new slatwalladmin.CollectionConfig(_this.$slatwall, 'GiftCardTransaction');
                transactionConfig.setDisplayProperties("giftCardTransactionID, creditAmount, debitAmount, giftCard.giftCardID");
                transactionConfig.addFilter('giftCard.giftCardID', _this.giftCard.giftCardID);
                transactionConfig.setAllRecords(true);
                var transactionPromise = _this.$slatwall.getEntity("GiftCardTransaction", transactionConfig.getOptions());
                transactionPromise.then(function (response) {
                    _this.transactions = response.records;
                    angular.forEach(_this.transactions, function (transaction, index) {
                        if (typeof transaction.creditAmount !== "string") {
                            _this.initialBalance += transaction.creditAmount;
                        }
                        if (typeof transaction.debitAmount !== "string") {
                            totalDebit += transaction.debitAmount;
                        }
                    });
                    _this.currentBalance = _this.initialBalance - totalDebit;
                    _this.balancePercentage = ((_this.currentBalance / _this.initialBalance) * 100);
                });
            };
            this.$slatwall = $slatwall;
            this.init();
        }
        return SWGiftCardBalanceController;
    })();
    slatwalladmin.SWGiftCardBalanceController = SWGiftCardBalanceController;
    var GiftCardBalance = (function () {
        function GiftCardBalance($slatwall, partialsPath) {
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.scope = {};
            this.bindToController = {
                giftCard: "=?",
                transactions: "=?",
                initialBalance: "=?",
                currentBalance: "=?",
                balancePercentage: "=?"
            };
            this.controller = SWGiftCardBalanceController;
            this.controllerAs = "swGiftCardBalance";
            this.link = function (scope, element, attrs) {
            };
            this.templateUrl = partialsPath + "/entity/giftcard/balance.html";
            this.restrict = "EA";
        }
        GiftCardBalance.$inject = ["$slatwall", "partialsPath"];
        return GiftCardBalance;
    })();
    slatwalladmin.GiftCardBalance = GiftCardBalance;
    angular.module('slatwalladmin')
        .directive('swGiftCardBalance', ["$slatwall", "partialsPath",
        function ($slatwall, partialsPath) {
            return new GiftCardBalance($slatwall, partialsPath);
        }
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=swgiftcardbalance.js.map
