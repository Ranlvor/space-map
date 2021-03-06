// @flow
import React from "react";

import AppBar from "@material-ui/core/AppBar";
import Toolbar from "@material-ui/core/Toolbar";
import Typography from "@material-ui/core/Typography";
import CircularProgress from "@material-ui/core/CircularProgress";

export type TopBarProps = {
  title: string,
  connected: boolean
};

export type TopBarState = {

};

export default class TopBar
  extends React.PureComponent<TopBarProps, TopBarState> {
  constructor(props: TopBarProps) {
    super(props);
  }

  render() {
    return (
      <AppBar position="static">
        <Toolbar>
          {this.renderConnectionIndicator()}
          <Typography variant="title">{this.props.title}</Typography>
        </Toolbar>
      </AppBar>
    );
  }

  renderConnectionIndicator() {
    if (this.props.connected) {
      return (<i style={{fontSize: 48}} className="mdi mdi-map"></i>);
    }
    return (
      <CircularProgress size={48} style={{color: "rgba(0, 0, 0, 0.54)"}} />
    );
  }
}
