import React from "react";

module.exports = {
  contextTypes: {
    info: React.PropTypes.object
  },

  onSuccess() {
    this.context.info.show('Success', 'OK');
  },

  onFailure() {
    this.context.info.show('Something went wrong');
  }
};
