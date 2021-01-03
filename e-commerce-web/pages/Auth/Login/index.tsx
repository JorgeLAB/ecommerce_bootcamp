import React from 'react';
import LoginForm from '../../../components/LoginForm';
import MainComponent from '../../../components/shared/MainComponent';


const Login: React.FC = () => {
  return (
    <MainComponent>
      <div className="text-center p-4">
        <h2>Acessar</h2> 
        <LoginForm titlePhrase = "Faça Login" buttonPhrase = "CONFIRME" />
      </div>
    </MainComponent>
  )
}

export default Login;