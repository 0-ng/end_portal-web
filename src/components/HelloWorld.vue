<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
    <h1>ip: {{ ip }}</h1>
    <h1>env: {{ env }}</h1>
    <h2>Essential Links</h2>
    <ul>
      <li>
        <a
          href="https://vuejs.org"
          target="_blank"
        >
          Core Docs
        </a>
      </li>
      <li>
        <a
          href="https://forum.vuejs.org"
          target="_blank"
        >
          Forum
        </a>
      </li>
      <li>
        <a
          href="https://chat.vuejs.org"
          target="_blank"
        >
          Community Chat
        </a>
      </li>
      <li>
        <a
          href="https://twitter.com/vuejs"
          target="_blank"
        >
          Twitter
        </a>
      </li>
      <br>
      <li>
        <a
          href="http://vuejs-templates.github.io/webpack/"
          target="_blank"
        >
          Docs for This Template
        </a>
      </li>
    </ul>
    <h2>Ecosystem</h2>
    <ul>
      <li>
        <a
          href="http://router.vuejs.org/"
          target="_blank"
        >
          vue-router
        </a>
      </li>
      <li>
        <a
          href="http://vuex.vuejs.org/"
          target="_blank"
        >
          vuex
        </a>
      </li>
      <li>
        <a
          href="http://vue-loader.vuejs.org/"
          target="_blank"
        >
          vue-loader
        </a>
      </li>
      <li>
        <a
          href="https://github.com/vuejs/awesome-vue"
          target="_blank"
        >
          awesome-vue
        </a>
      </li>
    </ul>
  </div>
</template>

<script>
  import { Partten } from "@/const";
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
            config.headers.portal_rest = (token || "").split(".")[1];
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
              window.location.href = "http://oauth-web/"
            } else {
              this.ip = res.data.data.ip
              this.env = window.sessionStorage.getItem('portal-token')
            }
          })
      },
      checkAuthorization(authorization){
        console.log("checkAuthorization " + authorization)
        var env = (authorization || "").split(".")
        if(env.length !== 4){
          console.log("env length not match")
          console.log("env", env)
          return false
        }
        if(env[2] !== Partten.APP_ENV){
          console.log("APP_ENV not match")
          return false
        }
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
        await this.$axios.post('/oauth/portalLogin', data, {headers: {'content-type': "application/x-www-form-urlencoded"}})
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
                window.location.href = "http://oauth-web/"
                // window.location.href = "http://127.0.0.1:8000/"
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
