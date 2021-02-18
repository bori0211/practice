module.exports = {
  apps: [
    {
      name: "flask",
      interpreter: "/usr/bin/python3",
      script: "app.py",
      /*watch: true,*/
      /*ignore_watch: ['node_modules', 'public'],*/
      /*out_file: '/var/log/express-stdout.log',*/
      /*error_file: '/var/log/express-stderr.log',*/
      log_type: "json",
      log_date_format: "YYYY-MM-DD HH:mm:ss"
    }
  ]
};
