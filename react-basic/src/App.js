import React, { Component } from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";

import Header from "./layout/header";
import HomePage from "./pages/home";
import ProductListPage from "./pages/product_list";
import ProductViewPage from "./pages/product_view";
import ProductFormPage from "./pages/product_form";
import AboutPage from "./pages/about";

class App extends Component {
  render() {
    return (
      <Router>
        <Header />
        <Switch>
          <Route path={"/"} component={HomePage} exact />
          <Route path={"/product"} component={ProductListPage} exact />
          <Route path={"/product/view/:id"} component={ProductViewPage} exact />
          <Route path={"/product/new"} component={ProductFormPage} exact />
          <Route path={"/product/modify/:id"} component={ProductFormPage} exact />
          <Route path={"/about"} component={AboutPage} exact />
        </Switch>
      </Router>
    );
  }
}

export default App;
