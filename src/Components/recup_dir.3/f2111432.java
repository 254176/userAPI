import React, { useState } from 'react';
import styled from 'styled-components';
import axios from 'axios';

const StyledLogin = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
  background-color: #f0f0f0;
`;

const FormContainer = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
`;

const LoginForm = styled.form`
  display: flex;
  flex-direction: column;
  background-color: #fff;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  width: 300px;
  margin-top: 20px;
`;

const FormInput = styled.input`
  margin-bottom: 15px;
  padding: 10px;
  font-size: 16px;
  border: 1px solid #ccc;
  border-radius: 4px;
`;

const FormButton = styled.button`
  padding: 10px;
  font-size: 16px;
  color: #fff;
  background-color: #9F3434;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s ease;

  &:hover {
    background-color: #7f2828;
  }
`;

const ErrorMessage = styled.p`
  color: red;
  font-size: 14px;
`;

export function Login() {
  const [isLogin, setIsLogin] = useState(true);
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  const toggleForm = () => {
    setIsLogin(!isLogin);
    setError('');
  };

  const handleLogin = (event) => {
    event.preventDefault();
    const user = users.find(user => user.username === username && user.password === password);
    if (user) {
      setError('Login successful');
      window.location.href = 'https://veomcourse.com/dashboard'; // Redirect to dashboard
    } else {
      setError('Invalid username or password');
    }
  };

  const handleSignup = async (event) => {
    event.preventDefault();
    try {
      const response = await axios.post('https://veomcourse.com:1200/users', {

name : '',
email : '',
address : '',
username,
password

      });
      console.log('Signup successful', response.data);
      setError('User created');
      setUsername('');
      setPassword('');
    } catch (error) {
      console.error('There was an error creating the user!', error);
      setError('Error creating user');
    }
  };

  return (
    <StyledLogin>
      <svg version="1.0" xmlns="http://www.w3.org/2000/svg"
           width="330.000000pt" height="83.000000pt" viewBox="0 0 330.000000 83.000000"
           preserveAspectRatio="xMidYMid meet">
        <metadata>
          Created by potrace 1.16, written by Peter Selinger 2001-2019
        </metadata>
        <g transform="translate(0.000000,83.000000) scale(0.100000,-0.100000)"
           fill="#000000" stroke="none">
          <path d="M1146 758 c-8 -18 -57 -132 -110 -252 -53 -120 -96 -220 -96 -222 0
            -2 25 -4 56 -4 l56 0 26 60 27 60 100 0 100 0 19 -48 c11 -26 23 -53 29 -59
            10 -14 117 -18 117 -5 -1 4 -50 117 -109 252 l-108 245 -47 3 c-44 3 -47 2
            -60 -30z"/>
          <path d="M2980 768 c-56 -29 -90 -78 -90 -130 0 -80 45 -123 160 -153 85 -22
            100 -31 100 -60 0 -29 -26 -45 -72 -45 -35 0 -111 31 -122 49 -12 20 -30 12
            -60 -26 l-30 -36 34 -28 c100 -84 283 -77 338 13 27 44 29 112 4 153 -20 32
            -75 61 -177 92 -52 16 -60 21 -60 43 0 51 67 59 147 19 21 -11 39 -19 42 -19
            3 0 17 17 30 37 24 34 24 38 9 55 -23 25 -116 58 -166 58 -24 0 -62 -10 -87
            -22z"/>
          <path d="M30 730 l0 -50 75 0 75 0 2 -197 3 -198 55 0 55 0 3 198 2 197 76 0
            75 0 -3 48 -3 47 -207 3 -208 2 0 -50z"/>
          <path d="M502 533 l3 -248 55 0 55 0 0 103 c0 98 1 102 17 83 9 -12 27 -21 40
            -21 19 0 43 -33 149 -203 l125 -202 62 -3 c37 -2 62 1 62 7 0 6 -58 101 -128
            213 l-128 203 30 20 c45 29 80 104 71 153 -9 58 -38 97 -87 121 -39 18 -62 21
            -186 21 l-142 0 2 -247z m268 134 c19 -9 26 -22 28 -49 4 -52 -23 -68 -113
            -68 l-70 0 3 65 4 65 61 0 c34 0 73 -6 87 -13z"/>
          <path d="M1391 772 c2 -4 49 -117 104 -250 l99 -242 47 0 46 0 98 238 c53 130
            100 243 102 250 4 9 -11 12 -55 12 l-60 0 -61 -156 c-34 -86 -61 -161 -61
            -167 0 -24 -16 11 -75 160 l-61 158 -63 3 c-35 2 -61 -1 -60 -6z"/>
          <path d="M1950 530 l0 -250 190 0 190 0 0 55 0 55 -135 0 -135 0 0 48 0 47
            117 0 118 0 0 50 0 50 -117 3 -118 3 0 44 0 44 133 3 132 3 0 45 0 45 -187 3
            -188 2 0 -250z"/>
          <path d="M2412 533 l3 -248 53 -3 52 -3 1 108 c0 101 1 107 16 86 9 -14 26
            -23 42 -23 22 -1 34 -14 76 -81 27 -45 54 -83 61 -86 6 -2 36 -3 67 -1 l56 3
            -58 91 -59 91 30 17 c45 27 68 72 68 134 0 63 -18 98 -68 132 -33 23 -45 25
            -189 28 l-153 3 2 -248z m284 122 c20 -27 17 -62 -6 -85 -16 -16 -33 -20 -95
            -20 l-75 0 0 66 0 66 81 -4 c66 -3 83 -7 95 -23z"/>
          <path d="M1070 166 c0 -8 10 -40 22 -71 24 -64 45 -69 63 -16 l11 34 10 -34
            c7 -23 16 -34 28 -34 15 0 25 16 42 68 l23 68 -21 -3 c-14 -2 -25 -15 -33 -37
            l-11 -34 -10 34 c-14 48 -39 49 -55 2 l-13 -38 -9 38 c-6 26 -14 37 -28 37
            -10 0 -19 -6 -19 -14z"/>
          <path d="M2650 160 c0 -11 7 -20 15 -20 11 0 15 -12 15 -50 0 -43 3 -50 20
            -50 17 0 20 7 20 50 0 38 4 50 15 50 10 0 15 -10 15 -30 0 -63 75 -93 118 -47
            28 30 28 68 -1 95 -28 26 -64 28 -89 5 -17 -15 -18 -15 -18 0 0 14 -10 17 -55
            17 -48 0 -55 -2 -55 -20z"/>
        </g>
      </svg>

      <FormContainer>
        {isLogin ? (
          <LoginForm onSubmit={handleLogin}>
            <h2>Login</h2>
            <FormInput
              type="text"
              placeholder="Username"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              required
            />
            <FormInput
              type="password"
              placeholder="Password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
            {error && <ErrorMessage>{error}</ErrorMessage>}
            <FormButton type="submit">Login</FormButton>
            <FormButton type="button" onClick={toggleForm}>
              Don't have an account? Sign Up
            </FormButton>
          </LoginForm>
        ) : (
          <LoginForm onSubmit={handleSignup}>
            <h2>Sign Up</h2>
            <FormInput
              type="text"
              placeholder="Username"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              required
            />
            <FormInput
              type="password"
              placeholder="Password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
            {error && <ErrorMessage>{error}</ErrorMessage>}
            <FormButton type="submit">Sign Up</FormButton>
            <FormButton type="button" onClick={toggleForm}>
              Already have an account? Login
            </FormButton>
          </LoginForm>
        )}
      </FormContainer>
    </StyledLogin>
  );
}

