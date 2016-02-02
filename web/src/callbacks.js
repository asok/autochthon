import React from "react";

module.exports = {
  contextTypes: {
    info: React.PropTypes.object
  },

  onSuccess(xhr) {
    this.context.info.show('Success', 'OK');
    return xhr;
  },

  onFailure(xhr) {
    this.context.info.show('Something went wrong');
    return xhr;
  }
};
