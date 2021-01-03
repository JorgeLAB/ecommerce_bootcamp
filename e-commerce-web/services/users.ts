import api from './api';
import User from '../dtos/User';

interface SignInData {
  email: string;
  password: string;
}

interface SignUpData {
  name: string;
  email: string;
  password: string;
  password_confirmation: string;
}

interface SignInResponse {
  data: User;
}

const UsersService = {
  signIn: ( { email, password }: SignInData ) => 
    api.post<SignInResponse>('/auth/v1/user/sign_in', {
      email,
      password
  }),
  signUp: ({ name, email, password, password_confirmation }: SignUpData) => 
    api.post<void>('/auth/v1/user', { name, email, password, password_confirmation }) // void post a entidade ainda é de um tipo idefinido
}

export default UsersService;