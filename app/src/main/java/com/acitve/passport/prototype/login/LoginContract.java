package com.acitve.passport.prototype.login;

public interface loginContract {

    interface View extends IView {
        // Prototype View Effects Behaviors
    }

    interface Presenter extends IPresenter<View> {
        // Presenter of loginContract.View
    }

}
