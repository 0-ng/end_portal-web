import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld'//组件的位置
import Fail from '@/components/Fail'//组件的位置

Vue.use(Router)
export const constantRoutes = [
    {
      path: '/',//系统的首页面url
      name: 'HelloWorld',
      component: HelloWorld, //对应上文的import
    }, {
      path: '/fail',//系统的首页面url
      name: 'Fail',
      component: Fail, //对应上文的import
    }
]

const createRouter = () => new Router({
  // mode: 'history', // require service support
  scrollBehavior: () => ({
    y: 0
  }),
  routes: constantRoutes
})

const router = createRouter()

// Detail see: https://github.com/vuejs/vue-router/issues/1234#issuecomment-357941465
export function resetRouter() {
  const newRouter = createRouter()
  router.matcher = newRouter.matcher // reset router
}

export default router
