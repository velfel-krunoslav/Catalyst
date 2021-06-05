pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;
contract Orders{
    uint public ordersCount = 0;

    struct Order{
        uint id;
        uint productId;
        uint amount;
        string date;
        uint status;    //  pending, confirmed, delivered, refunded
        uint buyerId;
        uint sellerId;
        string deliveryAddress;
        uint paymentType; //    0 - placanje pouzecem //   1 - eterijum
        uint price_numerator;
        uint price_denominator;
        string delivery_date;
    }

    mapping (uint => Order) public orders;

    event OrderCreated(uint id, uint OrderNumber);

    constructor() public{

        orders[0] = Order(0, 0, 1, "2021-02-01", 0, 52, 53, "Kralja Petra, Kragujevac, Srbija", 0, 43, 3, "ODMAH");
        orders[1] = Order(1, 1, 2, "2021-03-01", 0, 52, 53, "Kralja Petra, Kragujevac, Srbija", 0, 43, 3, "ODMAH");
        orders[2] = Order(2, 2, 1, "2021-03-01", 0, 52, 53, "Kralja Petra, Kragujevac, Srbija", 0, 43, 3, "ODMAH");
        orders[3] = Order(3, 3, 3, "2021-04-01", 0, 52, 53, "Kralja Petra, Kragujevac, Srbija", 0, 43, 3, "ODMAH");
        orders[4] = Order(4, 4, 1, "2021-04-01", 0, 52, 53, "Kralja Petra, Kragujevac, Srbija", 0, 43, 3, "ODMAH");
        orders[5] = Order(5, 5, 1, "2021-04-01", 0, 52, 53, "Kralja Petra, Kragujevac, Srbija", 0, 43, 3, "ODMAH");
        ordersCount = 6;
    }

    function createOrder(uint _productId, uint _amount, string memory _date,  uint _buyerId, uint _sellerId, string memory _deliveryAddress, uint _paymentType, uint _price_numerator, uint _price_denominator, string memory _delivery_date) public{

        orders[ordersCount++] = Order(ordersCount, _productId, _amount, _date, 0, _buyerId, _sellerId, _deliveryAddress, _paymentType, _price_numerator, _price_denominator, _delivery_date);
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
                    orders[i].sellerId,
                    orders[i].deliveryAddress,
                    orders[i].paymentType,
                orders[i].price_numerator,
                orders[i].price_denominator,
            orders[i].delivery_date
                );
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
    function checkForOrder(uint buyerId, uint productId) public returns (bool b){
        for (uint i=0; i< ordersCount; i++) {
            if (orders[i].buyerId == buyerId && orders[i].productId ==  productId)
                return true;
        }
        return false;
    }

    function getDeliveryOrders(uint _sellerId, uint totalOrders) public returns (Order[] memory){
        uint countTemp = 0;
        Order[] memory y = new Order[](totalOrders);
        for (uint i= 0; i < ordersCount; i++) {
            if (orders[i].sellerId == _sellerId){
                y[countTemp++] = Order(orders[i].id,
                    orders[i].productId,
                    orders[i].amount,
                    orders[i].date,
                    orders[i].status,
                    orders[i].buyerId,
                    orders[i].sellerId,
                    orders[i].deliveryAddress,
                    orders[i].paymentType,
                orders[i].price_numerator,
                orders[i].price_denominator,
                orders[i].delivery_date);
            }
        }
        return y;
    }
    function getDeliveryOrdersCount(uint _sellerId) public returns (uint count){
        uint countTemp = 0;
        for (uint i= 0; i < ordersCount; i++) {
            if (orders[i].sellerId == _sellerId){
                countTemp++;
            }
        }
        return countTemp;
    }
    function setStatus(uint _orderId, uint _status) public {
        for (uint i= 0; i < ordersCount; i++) {
            if (orders[i].id == _orderId){
                orders[i].status = _status;
                break;
            }
        }
    }

}