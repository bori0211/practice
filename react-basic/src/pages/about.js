import React, { Component } from "react";

import EmbodyImage1 from "../assets/front-end_back-end.png";
import EmbodyImage2 from "../assets/web-developer-terms-3.jpg";

class AboutPage extends Component {
  render() {
    return (
      <div className="content-main">
        <div className="content-wrapper">
          <div className="content">
            <div className="container-fluid text-center py-4">
              <img src={EmbodyImage1} /><br /><br />
              <img src={EmbodyImage2} />
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default AboutPage;
