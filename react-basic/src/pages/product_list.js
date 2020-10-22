import React, { Component } from "react";
import { Link } from "react-router-dom";
import axios from "axios";

class ProductListPage extends Component {
  constructor(props) {
    super(props);
    this.state = { products: [] };
  }

  componentDidMount() {
    axios.get("https://express.datafirst.co.kr/restful/products")
      .then(response => this.setState({ products: response.data }));
  }

  handleDelete(event) {
    if (confirm("정말 삭제하시겠습니까?")) {
      let productId = event.currentTarget.dataset.id;
      axios
        .delete(`https://express.datafirst.co.kr/restful/products/${productId}`)
        .then(response => {
          if (response.data.result) {
            //console.log("delete ok");
            //console.dir(this.props.history);
            // 같은 경로는 변경되지 않음 (state를 지움)
            //this.props.history.push("/product");
            let _products = Array.from(this.state.products);
            let i = 0;
            for (let i = 0; i < _products.length; i++) {
              //console.log(productId, _products[i].id);
              if (_products[i].id === parseInt(productId)) {
                _products.splice(i, 1);
                break;
              }
            }
            this.setState({
              products: _products
            });
          }
        });
    }
  }

  render() {
    const rows = this.state.products.map((product, i) => {
      return (
        <tr key={product.id}>
          <td className="text-center">{product.id}</td>
          <td className="text-center">{product.status}</td>
          <td className="text-left">
            {product.title}
            <Link to={`/product/view/${product.id}`}><i className="far fa-sticky-note fa-fw text-grey ml-1"></i></Link>
          </td>
          <td className="text-right">{product.price}</td>
          <td className="text-center">{product.createdAt}</td>
          <td className="text-center">
            <div className="btn-group">
              <Link className="btn btn-default btn-xs btn-flat" to={`/product/modify/${product.id}`}><i className="fas fa-pen fa-fw"></i></Link>
              <button className="btn btn-default btn-xs btn-flat delete-btn" type="button" data-id={product.id} onClick={this.handleDelete.bind(this)}><i className="fas fa-times fa-fw"></i></button>
            </div>
          </td>
        </tr >
      )
    });

    return (
      <div className="content-main" >
        <div className="content-wrapper">
          <div className="content">
            <div className="content-header">
              <h1 className="content-title">제품</h1>
              <div className="content-extra">
                <strong>{this.state.products.length}</strong>개의 제품
              </div>
            </div>

            <div className="content-body pb-4">
              <div className="container-fluid">
                <table className="table table-bordered table-striped">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>상태</th>
                      <th>제품명</th>
                      <th>가격</th>
                      <th>등록일</th>
                      <th>
                        <Link className="btn btn-default btn-xs btn-flat refresh-btn" to="/product/new"><i className="fas fa-plus fa-fw"></i></Link>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    {rows}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default ProductListPage;
