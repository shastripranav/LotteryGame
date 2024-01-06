// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Lottery{
    struct Info {
        string Name;
        uint Contri;
    }

    address [] private Users;
    address private Admin;
    address payable private Win;
    uint private Count;
    uint private Bal;
    bool private Stat;
    mapping (address=>Info) private Details;
    //mapping (address=>uint) Contribution;
    
    constructor (){
        Admin = msg.sender;
        Count = 0;
        Stat = true;
        Bal = 0;
        Win = payable (address (0));
    }

    function getAdmin() public view returns (address){
        return Admin;
    }
    function getWin() public view returns (address){
        return Win;
    }
    function getCount() public view returns (uint){
        return Count;
    }
    function getBal() public view returns (uint){
        return Bal;
    }
    function getStat() public view returns (bool){
        return Stat;
    }
    function getUser(uint x) public view returns (address){
        return Users[x];
    }
    function getName(address us) public view returns (string memory){
        return Details[us].Name;
    }
    function getContri(address us) public view returns (uint){
        return Details[us].Contri;
    }
    function getName(uint x) public view returns (string memory){
        return Details[Users[x]].Name;
    }
    function getContri(uint x) public view returns (uint){
        return Details[Users[x]].Contri;
    }
    function Register(string memory nm) public userck(msg.sender,Users) payable {
        require(msg.sender!=address(0),"Zero Address not accepted");
        require(Stat==true,"The Game is InActive !!");
        require(msg.value>0 && msg.value<5000000000000000000,"The Contribution must be greater zero & Less than 5 Eth");
        address uad = msg.sender;
        uint c = msg.value;
        Users.push(uad);
        Details[uad].Name = nm;
        Details[uad].Contri = c;
        Count++;
        Bal = Bal + c; //Bal +=c; 
    }

    function Random_no() public view returns (uint){
        uint no;
        no= uint(keccak256(abi.encodePacked(Admin,block.timestamp,block.difficulty)));
        return no;
    }
    function SelectWin() public AdminOnly{
        uint i = Random_no()%Count;
        Win = payable (Users[i]);
        Win.transfer(Bal);
        Bal = 0;
        Stat = false;
    }

    function Reset() public AdminOnly returns (bool){
        require(Bal==0,"Balance is Not Zero, Game is Active ");
        Count = 0;
        Stat = true;
        Bal = 0;
        Win = payable (address (0));
        delete Users;
        return true;
    }

    modifier AdminOnly {
        require(msg.sender==Admin,"  Only Admin has the Authority to run this");
       _;
    }

    modifier userck(address ad, address [] memory Usr ){
        bool ex=false;
        for(uint i=0;i<Usr.length;i++){
            if(Usr[i]==ad){ ex=true;break;}
        }
        require(!ex," User already Registered");
        _;
    }
}
