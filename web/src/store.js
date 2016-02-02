import { createStore } from "restful-material";

module.exports = createStore({
  all() {
    return this.GET('translations').
      then(data =>
           data.map(t => Object.keys(t).reduce((o, k) => o.set(k, t[k]), new Map())));
  },

  update(t) {
    return this.POST('translations', {
      locale: t.get('locale'),
      key: t.get('key'),
      value: t.get('value')
    });
  }
});
