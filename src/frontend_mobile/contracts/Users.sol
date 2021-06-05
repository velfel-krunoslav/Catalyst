pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;
contract Users {

    struct User{
        uint id;
        string name;
        string surname;
        string privateKey;
        string metamaskAddress;
        string photoUrl;
        string desc;
        string email;
        string phoneNumber;
        string homeAddress;
        string birthday;
        uint uType;
    }
    uint public usersCount = 0;
    mapping (uint => User) public users;
    event UserCreated(string user, uint userNumber);
    constructor() public{
        users[0] = User(52, "Jovan", "Petrovic", "bd57c6089a89d06291a39b45b4e8d6b1f43f3d527f9f6f180b046ce2c20aa03d", "29d57a9857418cfcbc467212c9bdc52e8747e14d", "https://ipfs.io/ipfs/QmYCykGuZMMbHcjzJYYJEMYWRrHr5g9gfkUqTkhkaC4gnm", "Poljoprivrednik sa 20 godina iskustva.", "jpetrovic@gmail.com", "0623496521", "Novi sad", "2020-3-3", 1);
        users[1] = User(53, "Dusan", "Jakovljevic", "a0162eb01a6784fedf6fe2317fdc5d787b3a8980a606bfe9a4897ca490bbbbb1", "370d110a4ca79a3a9552c0672d6a2478ecf9d72a", "https://ipfs.io/ipfs/QmYCykGuZMMbHcjzJYYJEMYWRrHr5g9gfkUqTkhkaC4gnm", "Poljoprivrednik sa 20 godina iskustva.", "djakovljevic@gmail.com", "0641369954", "Kragujevac", "2020-3-3", 1);
        users[2] = User(54, "Stevan", "Mitrovic", "41bdd0d42bc829903350f696e9a5063a43601dc6fd7dee3ee38c7c67dbbf06d8", "40ee840b5597a8a3c5755662e179d640662da66c", "https://ipfs.io/ipfs/QmYCykGuZMMbHcjzJYYJEMYWRrHr5g9gfkUqTkhkaC4gnm", "Poljoprivrednik sa 20 godina iskustva.", "smitrovic@gmail.com", "066321459", "Beograd", "2020-3-3", 1);

        usersCount = 3;
    }

    function createUser(string memory _name,
        string memory _surname,
        string memory _privateKey,
        string memory _metamaskAddress,
        string memory _photoUrl,
        string memory _desc,
        string memory _email,
        string memory _phoneNumber,
        string memory _homeAddress,
        string memory _birthday,
        uint _uType) public returns (uint) {

        users[usersCount] = User(users[usersCount - 1].id + 1, _name, _surname, _privateKey, _metamaskAddress, _photoUrl, _desc, _email, _phoneNumber, _homeAddress, _birthday, _uType);
        usersCount++;
        emit UserCreated(_name, usersCount - 1);
        return users[usersCount-1].id;

    }
    function checkForUser(string memory _metamaskAddress, string memory _privateKey) public returns (uint bl){

        for (uint i=0; i< usersCount; i++) {
            if (hashCompareWithLengthCheck(users[i].metamaskAddress, _metamaskAddress) && hashCompareWithLengthCheck(users[i].privateKey,  _privateKey))
                return users[i].id;
        }
        return usersCount;

    }

    function hashCompareWithLengthCheck(string memory a, string memory b) internal returns (bool) {
        if(bytes(a).length != bytes(b).length) {
            return false;
        } else {
            return keccak256(bytes(a)) == keccak256(bytes(b));
        }
    }

    function getUser(string memory privateKey, string memory accountAddress) public returns (User memory){
        User memory user;
        for (uint i= 0; i < usersCount; i++) {
            if (hashCompareWithLengthCheck(users[i].privateKey, privateKey) && hashCompareWithLengthCheck(users[i].metamaskAddress, accountAddress)){
                return users[i];
            }
        }
        return user;
    }
    function getUserById(uint id) public returns (User memory){
        User memory user;
        for (uint i= 0; i < usersCount; i++) {
            if (users[i].id == id){
                user = users[i];
                break;
            }
        }
        return user;
    }
    function editUser(uint _id,
        string memory _photoUrl,
        string memory _desc,
        string memory _email,
        string memory _phoneNumber,
        string memory _homeAddress) public {
        for (uint i= 0; i < usersCount; i++) {
            if (users[i].id == _id){
                users[i].photoUrl = _photoUrl;
                users[i].desc = _desc;
                users[i].email = _email;
                users[i].phoneNumber = _phoneNumber;
                users[i].homeAddress = _homeAddress;
                break;
            }
        }
    }

}
