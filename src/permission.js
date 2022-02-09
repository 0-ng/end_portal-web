import router from './router'

router.beforeEach((to, from, next) => {
  // 如果需要验证的话
  console.log(to.params)
  next('/fail')
  if (to.meta.requireAuth) {
    const authentication = window.sessionStorage.getItem('portal-token')
    if (authentication != null) {
        next()
    } else {

        next(`/login?redirect=${to.path}`)
    }
  } else {
    // 页面不需要验证
      next()
  }
})

