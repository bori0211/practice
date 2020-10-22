import React, { Component } from "react";

import logo from "../assets/logo.svg";

class HomePage extends Component {
  render() {
    return (
      <div className="content-main">
        <div className="content-wrapper">
          <div className="content">
            <div className="container-fluid text-center py-4">
              <h1 className="display-4">Hello, React!</h1>
              <img src={logo} className="App-logo" alt="logo" />
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default HomePage;
