import React from "react";
import { ActionDone } from "material-ui/lib/svg-icons";
import { TextField, Dialog, FlatButton, RaisedButton } from "material-ui";
import store from "./store";
import callbacks from "./callbacks";

module.exports = React.createClass({
  mixins: [callbacks],

  getInitialState() {
    return {
      open: false,
      translation: new Map()
    };
  },

  show(translation) {
    this.setState({
      translation: translation,
      open: true
    });
  },

  close(xhr) {
    this.setState({open: false});
    return xhr;
  },

  cb(xhr) {
    this.props.onSuccess();
    return xhr;
  },

  submit() {
    let t = this.state.translation;
    t.set('value', this.refs.field.getValue());
    store.update(t).then(this.onSuccess, this.onFailure).
          then(this.close).then(this.cb);
  },

  render() {
    return(
      <Dialog open={this.state.open} >
        <p>
          New value for key: {this.state.translation.get('key')}
        </p>
        <div>
          <TextField
            ref="field"
            multiLine={true}
            defaultValue={this.state.translation.get('value')} />
        </div>

        <div>
          <RaisedButton primary={false} label="Cancel" onClick={this.close} />
          <RaisedButton primary={true} label="OK" onClick={this.submit} />
        </div>
      </Dialog>
    );
  }
});
