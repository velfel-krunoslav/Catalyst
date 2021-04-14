pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;
contract Orders{
    uint public ordersCount = 0;

    struct Order{
        uint id;
        string productIds;
        uint priceDenominator;
        uint priceNominator;
        string date;
        uint status;    //  pending, confirmed, delivered, refunded
        uint buyerId;
    }

    mapping (uint => Order) public orders;

    event OrderCreated(string ids, uint OrderNumber);

    constructor() public{

        orders[0] = Order(0, "0", 12, 3, "2021-02-01", 0, 0);
        orders[1] = Order(1, "0", 12, 4, "2021-03-01", 0, 0);
        orders[2] = Order(2, "0", 12, 5, "2021-04-01", 0, 0);
        ordersCount = 3;
    }

    function createOrder(string memory _productIds, uint _buyerId, uint _priceDenominator, uint _priceNominator, string memory _date) public{

        orders[ordersCount++] = Order(ordersCount, _productIds, _priceDenominator, _priceNominator, _date, 0, _buyerId);
        emit OrderCreated(_productIds, ordersCount - 1);

    }
    function getOrders(uint _buyerId, uint totalOrders) public returns (Order[] memory){
        uint countTemp = 0;
        Order[] memory y = new Order[](totalOrders);
        for (uint i= 0; i < ordersCount; i++) {
            if (orders[i].buyerId == _buyerId){
                y[countTemp++] = Order(orders[i].id,
                    orders[i].productIds,
                    orders[i].priceDenominator,
                    orders[i].priceNominator,
                    orders[i].date,
                    orders[i].status,
                    orders[i].buyerId);
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