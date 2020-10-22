import React, { Component } from "react";
import { Link } from "react-router-dom";
import axios from "axios";

class ProductViewPage extends Component {
  constructor(props) {
    super(props);
    this.state = {
      id: 0,
      status: "대기중",
      title: "",
      description: "",
      cover_img: "",
      price: 0
    };
  }

  componentDidMount() {
    let productId = this.props.match.params.id;
    axios
      .get(`https://express.datafirst.co.kr/restful/products/${productId}`)
      .then(response => {
        console.log(response);
        this.setState({
          id: response.data.id,
          status: response.data.status,
          title: response.data.title,
          description: response.data.description,
          cover_img: response.data.cover_img,
          price: response.data.price
        });
      });
  }

  render() {
    return (
      <div className="content-main">
        <div className="content-wrapper">
          <div className="content">
            <div className="content-header">
              <h1 className="content-title">제품</h1>
              <div>
                <Link className="btn btn-default btn-xs btn-flat list-btn" to="/product"><i className="fas fa-level-up-alt fa-rotate-270 fa-fw"></i></Link>
              </div>
            </div>
            <div className="content-body">
              <div className="container-fluid">
                <strong>{this.state.title}</strong>
                <p className="pt-2">{this.state.description}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default ProductViewPage;
