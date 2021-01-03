import React from 'react';
import styles from '../../../styles/LateralMenu.module.css';
import Logo from '../Logo';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faSignal, faUser, faGamepad, faCheckSquare, faLaptop, faTicketAlt, faDollarSign, faSignOutAlt } from '@fortawesome/free-solid-svg-icons';
import Link from 'next/link';

const LateralMenu: React.FC = () => {
  return( 
    <div className={styles.background}>
      <Logo />

      <div className={styles.list}>
        
        <Link href="/Admin">
          <a>
            <FontAwesomeIcon color="var(--color-gray-light)" icon={faSignal} className="mr-3"/>
            Painel Inicial
            <hr />
          </a>
        </Link>

        <Link href="/Admin/User/List">
          <a>
            <FontAwesomeIcon color="var(--color-gray-light)" icon={faUser} className="mr-3"/>
            Usuários
            <hr />
          </a>
        </Link>
        <Link href="/Admin/Products/List">
          <a>
            <FontAwesomeIcon color="var(--color-gray-light)"icon={faGamepad} className="mr-3"/>
            Produtos
            <hr />
          </a>
        </Link>
        <Link href="/Admin/Categories/List">
          <a>
            <FontAwesomeIcon color="var(--color-gray-light)"icon={faCheckSquare} className="mr-3"/>
            Categories
            <hr />
          </a>
        </Link>
        <Link href="/Admin/SystemRequirements/List">
          <a>
            <FontAwesomeIcon color="var(--color-gray-light)"icon={faLaptop} className="mr-3"/>
            Requisitos de sistemas 
            <hr />
          </a>
        </Link>
        <Link href="/Admin/Coupons/List">
          <a>
            <FontAwesomeIcon color="var(--color-gray-light)"icon={faTicketAlt} className="mr-3"/>
            Coupons
            <hr />
          </a>
        </Link>
        <Link href="/Admin/#">
          <a>
            <FontAwesomeIcon color="var(--color-gray-light)"icon={faDollarSign} className="mr-3"/>
            Financeiro
            <hr />
          </a>
        </Link>
        <Link href="/Admin/#">
          <a>
            <FontAwesomeIcon color="var(--color-gray-light)"icon={faSignOutAlt} className="mr-3"/>
            Sair
            <hr />
          </a>
        </Link>
      </div>
    </div>
  )
}

export default LateralMenu;