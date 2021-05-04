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

        users[0] = User(0, "Petar", "Petrovic", "key1", "address1", "assets/icons/UserCircle.png", "opis proizvodjaca", "email@gmail.com", "1351351351", "Novi sad", "2020-3-3", 1);
        users[1] = User(1, "Marko", "Markovic", "key2", "address2", "assets/icons/UserCircle.png", "opis proizvodjaca", "email@gmail.com", "1351351351", "Novi sad", "2020-3-3", 1);
        usersCount = 2;
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

        users[usersCount++] = User(usersCount, _name, _surname, _privateKey, _metamaskAddress, _photoUrl, _desc, _email, _phoneNumber, _homeAddress, _birthday, _uType);
        emit UserCreated(_name, usersCount - 1);
        return usersCount-1;

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
}
