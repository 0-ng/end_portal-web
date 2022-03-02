<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
    <h1>user: {{ username }}</h1>
    <h1>ip: {{ ip }}</h1>
    <h1>env: {{ env }}</h1>
    <button @click="LogoutXXX()">退出登录</button>
  </div>
</template>
<script>
  import { Partten } from "@/const";
  import  jwt  from  'jsonwebtoken'

  export default {
    name: 'HelloWorld',
    data() {
      return {
        msg: '登陆成功',
        ip: '',
        env: ''
      }
    },
    mounted: async function() {
      var Authorization = await this.getAuthorization()
      console.log("mounted", Authorization)
      this.setRestEnv(Authorization)
      this.setAuthorization(Authorization)
      this.getData();
    },
    methods: {
      LogoutXXX(){
        window.sessionStorage.removeItem('portal-token')
        window.location.href = "http://127.0.0.1:8000/?logout=1"
      },
      // 根据参数名获取url中的参数
      GetQueryString(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
        var r = window.location.search.substr(1).match(reg); //获取url中"?"符后的字符串并正则匹配
        var context = "";
        if (r != null)
          context = r[2];
        reg = null;
        r = null;
        return context == null || context == "" || context == "undefined" ? "" : context;
      },

      getParamsData(params) {
        var data = '';
        for (let attr in params) {
          data += '&' + attr + '=' + encodeURIComponent(params[attr]);
        }//转键值对，然后设置下content-type。axios的content-type是application/json的，不是键值对
        data = data.substring(1)
        return data
      },
      setAuthorization(token) {
        this.$axios.interceptors.request.use(config => {
          if (token) {  // 判断是否存在token，如果存在的话，则每个http header都加上token
            config.headers.Authorization = token;
            console.log('interceptors config=', config)
          }
          return config
        }, error => {
          return Promise.reject(error)
        })
      },
      setRestEnv(token) {
        console.log("set restENV ", token)
        this.$axios.interceptors.request.use(config => {
          if (token) {  // 判断是否存在token，如果存在的话，则每个http header都加上token
            let jwt = require('jsonwebtoken');
            let env = jwt.decode(token)
            config.headers.portal_rest = env['portal_rest']
            console.log('interceptors config=', config)
          }
          return config
        }, error => {
          return Promise.reject(error)
        })
      },
      getData() {
        this.$axios.get('/api/index')
          .then((res) => {
            if (res.data.code !== "0") {
              window.location.href = "http://127.0.0.1:8000/"
            } else {
              this.ip = res.data.data.ip
              this.env = "portal-web-" + Partten.APP_ENV
              this.username = res.data.data.username
            }
          })
      },
      checkAuthorization(authorization){
        console.log("checkAuthorization " + authorization)
        if(authorization == null){
          return false
        }
        let  jwt = require('jsonwebtoken');
        let env = jwt.decode(authorization)
        if(env == null){
          return false
        }
        console.log("decode", env)
        if(env['portal_web'] !== Partten.APP_ENV){
          console.log("APP_ENV not match")
          return false
        }
        // if(env['username'] !== this.GetQueryString('username')){
        //   console.log("user not match")
        //   return false
        // }

        return true
      },
      getAuthorization: async function() {
        console.log("APP_ENV", Partten.APP_ENV)
        var Authorization = window.sessionStorage.getItem('portal-token')
        if(this.checkAuthorization(Authorization)){
          console.log("sessionStorage success")
          return Authorization
        }
        var params = {code: this.GetQueryString('code')}
        var data = this.getParamsData(params)
        await this.$axios.post('/oauth/api/portalLogin', data, {headers: {'content-type': "application/x-www-form-urlencoded"}})
          .then((res) => {
            if (res.data.code !== "0") {
              Authorization = ""
            }else{
              Authorization = res.data.data.token
              console.log("getAuthorization ", Authorization)
              if(this.checkAuthorization(Authorization)){
                window.sessionStorage.setItem('portal-token', Authorization)
                console.log("get Authorization success")
              }else{
                console.log("get Authorization fail")
                window.location.href = "http://127.0.0.1:8000/"
              }
            }
          })
        return Authorization
      }
    }
  }
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
  h1, h2 {
    font-weight: normal;
  }

  ul {
    list-style-type: none;
    padding: 0;
  }

  li {
    display: inline-block;
    margin: 0 10px;
  }

  a {
    color: #42b983;
  }
</style>
