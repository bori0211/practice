import React, { Component } from "react";
import { Link } from "react-router-dom";
import axios from "axios";

class ProductFormPage extends Component {
  constructor(props) {
    super(props);
    if (this.props.match.path === "/product/new") this.act = "new";
    if (this.props.match.path === "/product/modify/:id") this.act = "modify";
    this.state = {
      title: ""
    };
  }

  componentDidMount() {
    if (this.act === "new") {
      this.setState({
        id: 0,
        status: "대기중",
        title: "",
        description: "from React App",
        cover_img: "",
        price: 12.99
      });
    }

    if (this.act === "modify") {
      let productId = this.props.match.params.id;
      axios
        .get(`https://express.datafirst.co.kr/restful/products/${productId}`)
        .then(response => {
          this.setState({
            id: response.data.id,
            status: response.data.status,
            title: response.data.title,
            description: response.data.description,
            cover_img: response.data.cover_img === null ? "" : response.data.cover_img,
            price: response.data.price
          });
        });
    }
  }

  handleChange(event) {
    this.setState({
      [event.target.name]: event.target.value
    });
  }

  handleSubmit(event) {
    event.preventDefault();

    if (event.target.act.value === "insert") {
      axios
        .post("https://express.datafirst.co.kr/restful/products", this.state)
        .then(response => {
          if (response.data.result) {
            this.props.history.push("/product");
          }
        });
    }

    if (event.target.act.value === "update") {
      let productId = this.props.match.params.id;
      axios
        .put(`https://express.datafirst.co.kr/restful/products/${productId}`, this.state)
        .then(response => {
          if (response.data.result) {
            this.props.history.push("/product");
          }
        });
    }
  }

  render() {
    let actForm = "";
    if (this.act === "new") actForm = "insert";
    if (this.act === "modify") actForm = "update";

    return (
      <div className="content-main">
        <div className="content-wrapper">
          <form method="post" onSubmit={this.handleSubmit.bind(this)}>
            <div className="content">
              <div className="content-header">
                <h1 className="content-title">제품</h1>
                <div>
                  <Link className="btn btn-default btn-xs btn-flat list-btn" to="/product"><i className="fas fa-level-up-alt fa-rotate-270 fa-fw"></i></Link>
                </div>
              </div>

              <div className="content-body">
                <div className="container-fluid">
                  <div className="form-group row">
                    <label className="col-md-3 col-form-label text-md-right"><span className="text-danger">*</span> 제품명</label>
                    <div className="col-md-9">
                      <div className="form-inline">
                        <input className="form-control" type="text" name="title" value={this.state.title} maxLength="60" onChange={this.handleChange.bind(this)} />
                      </div>
                    </div>
                  </div>
                </div>

                <div className="content-footer">
                  <button className="btn btn-primary save-btn" type="submit">저장</button>
                </div>
              </div>
            </div>
            <input type="hidden" name="act" value={actForm} />
          </form>
        </div>
      </div>
    );
  }
}

export default ProductFormPage;
