import React from 'react';
import { Row, Col, InputGroup, FormControl } from 'react-bootstrap';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faSearch, faShoppingCart, faUserCircle } from '@fortawesome/free-solid-svg-icons';

import  Logo  from '../../Logo';

import styles from '../../../../styles/Header.module.css';

const StorefrontHeader: React.FC = () => {
	return (
		<header className={styles.background}>
		<Row>	
			<Col md={7} className="mt-2" >
				<Logo />
			</Col>
			<Col md={5} className="mt-2 text-center">
				<Row>
					<Col md={6} className="mb-4 mb-md-0" >
						<InputGroup>
							<FormControl placeholder="Pesquisar Produto" className={styles.input} />
						</InputGroup>
					</Col>
					<Col md={6}>
						<Row>
							<Col md={4} xs={4}>
								<FontAwesomeIcon icon={faSearch} color="var(--color-gray-light)" />
							</Col>
							<Col md={4} xs={4}>
								<FontAwesomeIcon icon={faShoppingCart} color="var(--color-gray-light)" />
							</Col>
							<Col md={4} xs={4}>
								<FontAwesomeIcon icon={faUserCircle} color="var(--color-gray-light)" />
							</Col>
						</Row>
					</Col>          			
				</Row>
			</Col>       
		</Row>
		</header>     
	 )
}

export default StorefrontHeader;