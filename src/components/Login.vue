
<!--&lt;!&ndash;<script src="../../../../../vue-template/login/mk2048_378272020_08_14_bjjaa11jh0hj/js/index.js"></script>&ndash;&gt;-->
<!--<template>-->
<!--  <div class="login">-->
<!--    {{ message }}<br/>-->
<!--    <input v-model="username" placeholder="用户名"><br/>-->
<!--    <input v-model="password" placeholder="密码"><br/>-->
<!--    <button v-on:click="login">登陆 </button>-->
<!--  </div>-->
<!--</template>-->

<!--<script>-->
<!--    export default {-->
<!--      name: "login",-->
<!--      data() {-->
<!--        return {-->
<!--          message: '登陆页面',-->
<!--          username: '',-->
<!--          password: ''-->
<!--        }-->
<!--      },-->
<!--      http: {-->
<!--        headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}-->
<!--      },-->
<!--      methods: {-->
<!--        login: function () {-->
<!--          var _this = this;-->
<!--          console.log(_this.username+_this.password);-->
<!--          _this.$http.post('api/login', {-->
<!--                username: _this.username,-->
<!--                password: _this.password-->
<!--          },{emulateJSON:true}-->
<!--          )-->
<!--            .then(function (response) {-->
<!--              var errorcode = response.data.code;-->
<!--              if (errorcode == "200") {-->
<!--                _this.$router.push(-->
<!--                  { path: '/HelloWorld',-->
<!--                    query: {-->
<!--                      user: response.data.data,-->
<!--                    }-->
<!--                  });-->
<!--              } else {-->
<!--                _this.$router.push({ path: '/Fail' });-->
<!--              }-->
<!--            })-->
<!--            .catch(function (error) {-->
<!--              console.log(error);-->
<!--            });-->
<!--        }-->
<!--      }-->

<!--    }-->
<!--</script>-->

<!--<style scoped>-->

<!--</style>-->
<template>
  	<div class="login_page fillcontain">
	  	<transition name="form-fade" mode="in-out">
	  		<section class="form_contianer" v-show="showLogin">
		  		<div class="manage_tip">
		  			<p>elm后台管理系统</p>
		  		</div>
		    	<el-form :model="loginForm" :rules="rules" ref="loginForm">
					<el-form-item prop="username">
						<el-input v-model="loginForm.username" placeholder="用户名"><span>dsfsf</span></el-input>
					</el-form-item>
					<el-form-item prop="password">
						<el-input type="password" placeholder="密码" v-model="loginForm.password"></el-input>
					</el-form-item>
					<el-form-item>
				    	<el-button type="primary" @click="submitForm('loginForm')" class="submit_btn">登录</el-button>
				  	</el-form-item>
				</el-form>
				<p class="tip">温馨提示：</p>
				<p class="tip">未登录过的新用户，自动注册</p>
				<p class="tip">注册过的用户可凭账号密码登录</p>
	  		</section>
	  	</transition>
  	</div>
</template>

<script>
	import {login, getAdminInfo} from '@/api/getData'
	import {mapActions, mapState} from 'vuex'

	export default {
	    data(){
			return {
				loginForm: {
					username: '',
					password: '',
				},
				rules: {
					username: [
			            { required: true, message: '请输入用户名', trigger: 'blur' },
			        ],
					password: [
						{ required: true, message: '请输入密码', trigger: 'blur' }
					],
				},
				showLogin: false,
			}
		},
		mounted(){
			this.showLogin = true;
			if (!this.adminInfo.id) {
    			this.getAdminData()
    		}
		},
		computed: {
			...mapState(['adminInfo']),
		},
		methods: {
			...mapActions(['getAdminData']),
			async submitForm(formName) {
				this.$refs[formName].validate(async (valid) => {
					if (valid) {
						const res = await login({user_name: this.loginForm.username, password: this.loginForm.password})
						if (res.status == 1) {
							this.$message({
		                        type: 'success',
		                        message: '登录成功'
		                    });
							const res2 = await env({user_name: this.loginForm.username})
              this.$router.push(res2.url)
						}else{
							this.$message({
		                        type: 'error',
		                        message: res.message
		                    });
						}
					} else {
						this.$notify.error({
							title: '错误',
							message: '请输入正确的用户名密码',
							offset: 100
						});
						return false;
					}
				});
			},
		},
		watch: {
			adminInfo: function (newValue){
				if (newValue.id) {
					this.$message({
                        type: 'success',
                        message: '检测到您之前登录过，将自动登录'
                    });
					this.$router.push('manage')
				}
			}
		}
	}
</script>

<style lang="less" scoped>
/*<style scoped>*/
	@import '../style/mixin';
	.login_page{
		background-color: #324057;
	}
	.manage_tip{
		position: absolute;
		width: 100%;
		top: -100px;
		left: 0;
		p{
			font-size: 34px;
			color: #fff;
		}
	}
	.form_contianer{
		.wh(320px, 210px);
		.ctp(320px, 210px);
		padding: 25px;
		border-radius: 5px;
		text-align: center;
		background-color: #fff;
		.submit_btn{
			width: 100%;
			font-size: 16px;
		}
	}
	.tip{
		font-size: 12px;
		color: red;
	}
	.form-fade-enter-active, .form-fade-leave-active {
	  	transition: all 1s;
	}
	.form-fade-enter, .form-fade-leave-active {
	  	transform: translate3d(0, -50px, 0);
	  	opacity: 0;
	}
</style>
