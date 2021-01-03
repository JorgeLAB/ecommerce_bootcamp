import React from 'react';
import withAuthAdmin from '../../components/withAuthAdmin';

const Home: React.FC = () => {
	return <h1> Apenas um teste </h1>
}

export default withAuthAdmin(Home);
