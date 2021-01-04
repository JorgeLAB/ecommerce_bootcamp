import React from 'react';
import styles from '../../../styles/AdminTitle.module.css';

interface TitleAndPath {
  title: String,
  path: String
}

const TitleAndPath: React.FC<TitleAndPath> = ({ title, path}) => {
  return (
    <div>
      <h4>{ title }</h4>
      <span className={styles.styledPath}> { path } </span>
    </div>
    )
}  

export default TitleAndPath;