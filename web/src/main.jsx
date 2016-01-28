import React from "react";
import DOM from "react-dom";
import Router, {Route, DefaultRoute, Redirect } from "react-router";
import Restful from "restful-material";
import { CircularProgress, Styles, RaisedButton } from "material-ui";

let router = Router.create();

Restful.configure({
  ajax: {
    url: document.querySelector('meta[name="path"]').content,
    beforeSend: (xhr)=> {
      DOM.render(<CircularProgress size={4} />, document.getElementById('spinner'));
    },
    onFailure: (xhr)=> {
      console.log(xhr);
      return xhr;
    },
    onCompleted: ()=> {
      DOM.unmountComponentAtNode(document.getElementById('spinner'));
    }
  }
});

import injectTapEventPlugin from "react-tap-event-plugin";
import Translations from "./Translations";

injectTapEventPlugin();

let AppRoutes = (
  <Route name="root" path="/">
    <DefaultRoute handler={Translations} />
  </Route>
);

router.addRoutes(AppRoutes);

let App = React.createClass({
  mixins: [Restful.Info.Mixin],

  render() {
    return (
      <div>
        {this.infoComponent()}
        {this.props.children}
      </div>
    );
  }
});

router.run(function(Handler) {
  DOM.render(<App> <Handler /> </App>,
             document.getElementById("content"));
});
