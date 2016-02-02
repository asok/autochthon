import React from "react";
import { Table } from "restful-material";
import { Paper,
         SelectField,
         MenuItem } from "material-ui";
import callbacks from "./callbacks";
import store from "./store";
import Dialog from "./Dialog";

let spec = {
  'Locale': {key: 'locale'},
  'Key': {key: 'key'},
  'Value': {key: 'value'}
};

module.exports = React.createClass({
  mixins: [callbacks],

  getInitialState() {
    return {
      translations: [],
      openDialog: false,
      translationToEdit: new Map()
    };
  },

  _onAll(translations) {
    this.setState({translations: translations});
  },

  _onCellClick(row, col) {
    if(col == 3)
      this.refs.dialog.show(this.refs.table.getResource(row));
  },

  componentWillMount() {
    store.all().then(this._onAll, this.onFailure);
  },

  _onUpdate(translation) {
    this.refs.table.forceUpdate();
  },

  render() {
    return(
      <div>
        <Paper style={{padding: 10}}>
          <div>
            <Table
              spec={spec}
              ref="table"
              tableProps={{onCellClick: this._onCellClick}}
              resources={this.state.translations || []} />
          </div>
        </Paper>

        <Dialog ref="dialog" onSuccess={this._onUpdate} />
      </div>
    );
  }
});
