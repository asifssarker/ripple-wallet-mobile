package ripple.wallet.mobile.tabs;

import angular.route.Route;
import angular.service.Location;
import angular.service.Scope;
import angular.service.TypedScope;

/**
 * ...
 * @author Ivan Tivonenko
 */

typedef Message = {
    backend: String,
    message: String
}

typedef TabLoginScope = {
                            user: {
                                firstName : String,
                                lastName : String
                            },
                            username: String,
                            password: String,
                            verifying: String,
                            status: String,
                            backendMessages: Array<Message>,
                            ajax_loading: Bool
                        }

class TabLogin {

    var location: Location;
    var scope: TypedScope<TabLoginScope>;
    var route: Route;

    public function new(scope: TypedScope<TabLoginScope>, location: Location, route: Route) {
        trace('TabLogin new');
        this.location = location;
        this.scope = scope;
        this.route = route;
        //scope.set("data", {username: 'Test user'} );
        scope.user = {
            firstName: 'Ivan',
            lastName: 'Hottabich'
        }
//        scope.ajax_loading = true;
    }

//    @:keep public function goBalance() {
//        trace('BBBBBBBB');
//        location.path('/balance');
//    }

    @:keep public function submitForm() {
        trace('submitForm!!!');
        this.scope.status = 'Got!';
        this.scope.backendMessages = [
            {
                backend: 'from backend!',
                message: 'got message'
            }
        ];
//        trace(this.route.routes);
//        trace(this.route.current);
//        this.route.updateParams({ d: 2 });
    }

}