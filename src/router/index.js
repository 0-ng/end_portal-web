import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld'//组件的位置

Vue.use(Router)
export default new Router({
  routes: [
    {
      path: '/',//系统的首页面url
      name: 'HelloWorld',
      component: HelloWorld//对应上文的import
    }
  ]
})
