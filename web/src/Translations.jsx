import React from "react";
import { Table } from "restful-material";
import { Paper,
         SelectField,
         MenuItem } from "material-ui";
import callbacks from "./callbacks";
import store from "./store";
import Dialog from "./Dialog";

let spec = {
  'Key': {key: 'key'},
  'Value': {key: 'value'}
};

let groupBy = (resources, by) => {
  return resources.reduce((out, r) => {
    let v = r.get(by);

    if(out.has(v))
      out.set(v, out.get(v).concat([r]));
    else
      out.set(v, []);

    return out;
  }, new Map());
};

module.exports = React.createClass({
  mixins: [callbacks],

  getInitialState() {
    return {
      translations: new Map(),
      availableLocales: [],
      currentLocale: null,
      openDialog: false,
      translationToEdit: new Map()
    };
  },

  _onAll(translations) {
    translations = groupBy(translations, 'locale');
    let availableLocales = [...translations.keys()];

    this.setState({
      translations: translations,
      availableLocales: availableLocales,
      currentLocale: availableLocales[0]
    });
  },

  _updateCurrentLocale(_, __, v) {
    this.setState({currentLocale: v});
  },

  _onCellClick(row, col) {
    if(col == 2)
      this.refs.dialog.show(this.refs.table.getResource(row));
  },

  componentWillMount() {
    store.all().then(this._onAll, this.onFailure);
  },

  render() {
    return(
      <div>
        <Paper style={{marginBottom: 20, padding: 10}}>
          <span>Select locale: </span>

          <SelectField
            value={this.state.currentLocale}
            onChange={this._updateCurrentLocale} >

            {this.state.availableLocales.map((locale, i) =>
               <MenuItem key={i} value={locale} primaryText={locale} />)}
          </SelectField>
        </Paper>

        <Paper style={{padding: 10}}>
          <div>
            <Table
              spec={spec}
              ref="table"
              tableProps={{onCellClick: this._onCellClick}}
              resources={this.state.translations.get(this.state.currentLocale) || []} />
          </div>
        </Paper>

        <Dialog ref="dialog" />
      </div>
    );
  }
});
