import React, { Component } from "react";
import { NavLink } from "react-router-dom";

class Header extends Component {
  render() {
    //console.log(this.props);
    return (
      <React.Fragment>
        <nav className="navbar fixed-top">
          <ul className="navbar-nav">
            <li className="nav-item"><NavLink className="nav-link" exact activeClassName="selected" to="/">HOME</NavLink></li>
            <li className="nav-item"><NavLink className="nav-link" activeClassName="selected" to="/product">PRODUCT</NavLink></li>
            <li className="nav-item"><NavLink className="nav-link" activeClassName="selected" to="/about">ABOUT</NavLink></li>
          </ul>
        </nav>
      </React.Fragment>
    );
  }
}

export default Header;
