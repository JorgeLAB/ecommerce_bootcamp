export default interface ApiData {
  'access-token': string;
  'client': string;
  expiry: number;     // porque de não ser uma string 'expiry'
  'token-type': string;
  uid: string;
}	