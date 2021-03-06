package ripple.wallet.mobile.services;

import thx.promise.Promise;
import thx.Error;

import angular.service.RootScope;
import ripple.lib.RippleRestClient;

/**
 * ...
 * @author Ivan Tivonenko
 */
class History {

    var history(get, never): Array<PaymentData>;

    var id: Id;
    var api: RippleRestClient;
    var scope: RootScope;
    var _history: Array<PaymentData>;
    var currentPage = 0;

    public function new(id: Id, scope: RootScope) {
        this.id = id;
        this.scope = scope;
        this.api = new RippleRestClient();
        this.scope.watch('loginStatus', onLogin);
        this._history = [];
        this.setHistory();
    }

    public function loadNext() : Promise<Bool> {
        if (!this.id.loginStatus) {
            return Promise.value(true);
        }
        this.currentPage += 1;
        return Promise.create(function(resolve : Bool -> Void, reject : Error -> Void) {
//            trace('loading $currentPage');
            this.load(this.currentPage).either(function(data) {
//                trace('--- got');
                trace(data);
                if (data.length > 0) {
                    this._history = this._history.concat(data);
                }
                resolve(data.length > 0);
                if (data.length > 0) {
                    this.setHistory();
                }
            }, function(e) {
                resolve(false);
            });
        });
    }

    function load(page: Int): Promise<Array<PaymentData>> {
        if (this.id.loginStatus) {
            return Promise.create(function(resolve : Array<PaymentData> -> Void, reject : Error -> Void) {
                this.api.payments(this.id.address, { results_per_page: 20, exclude_failed: true, page: page } ).either(function(data) {
                    if (data.success) {
                        var d = data.payments;
                        Lambda.iter(d, function(p) {
                            var timestamp = p.payment.timestamp;
                            var date: Date = untyped __js__('new Date(timestamp)');
                            Reflect.setField(p.payment, 'date', date);
                        });
                        resolve(d);
                    } else {
                        resolve([]);
                    }
                }, function(e) {
                    trace(e);
                    resolve([]);
                });
            });
        } else {
            return Promise.value([]);
        }
    }

    function onLogin(v: Bool, v2: Bool) {
//        trace('History::onLogin($v, $v2)');
        if (!v) {
            this.currentPage = 0;
            this._history = [];
            this.setHistory();
        }
    }

    function setHistory() {
//        trace('set paymentsHistory ${_history.length}');
        this.scope.safeApply(function() {
            this.scope.set('paymentsHistory', this._history);
        });
    }

    inline function get_history() {
        return this._history;
    }

}
