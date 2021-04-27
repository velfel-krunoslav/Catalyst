pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;
contract Orders{
    uint public ordersCount = 0;

    struct Order{
        uint id;
        uint productId;
        uint amount;
        string date;
        uint status;
        uint buyerId;   //  pending, confirmed, delivered, refunded
        uint sellerId;
        //adresa
        //nacin placanja

    }

    mapping (uint => Order) public orders;

    event OrderCreated(uint id, uint OrderNumber);

    constructor() public{

        orders[0] = Order(0, 0, 1, "2021-02-01", 0, 0, 0);
        orders[1] = Order(1, 1, 2, "2021-03-01", 0, 0, 0);
        orders[2] = Order(2, 2, 1, "2021-03-01", 0, 0, 0);
        orders[3] = Order(3, 3, 3, "2021-04-01", 0, 0, 0);
        orders[4] = Order(4, 4, 1, "2021-04-01", 0, 0, 0);
        orders[5] = Order(5, 5, 1, "2021-04-01", 0, 1, 0);
        ordersCount = 6;
    }

    function createOrder(uint _productId, uint _amount, string memory _date,  uint _buyerId, uint _sellerId) public{

        orders[ordersCount++] = Order(ordersCount, _productId, _amount, _date, 0, _buyerId, _sellerId);
        emit OrderCreated(_productId, ordersCount - 1);

    }
    function getOrders(uint _buyerId, uint totalOrders) public returns (Order[] memory){
        uint countTemp = 0;
        Order[] memory y = new Order[](totalOrders);
        for (uint i= 0; i < ordersCount; i++) {
            if (orders[i].buyerId == _buyerId){
                y[countTemp++] = Order(orders[i].id,
                    orders[i].productId,
                    orders[i].amount,
                    orders[i].date,
                    orders[i].status,
                    orders[i].buyerId,
                    orders[i].sellerId);
            }
        }
        return y;
    }
    function getOrdersCount(uint buyerId) public returns (uint count){
        uint countTemp = 0;
        for (uint i= 0; i < ordersCount; i++) {
            if (orders[i].buyerId == buyerId){
                countTemp++;
            }
        }
        return countTemp;
    }
}