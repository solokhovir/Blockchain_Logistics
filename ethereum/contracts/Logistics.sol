// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

contract Logistics {
    address owner;
    uint balanceReceived;

    constructor() {
        owner = msg.sender;
        admins[owner]._isAdmin = true;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Not an owner!");
        _;
    }

    enum Status { In_Production, Paid, In_Stock, Delivered, Sent, Canceled, Returned_To_Warehouse }
    Status status_choice;

    struct Admin {
        bool _isAdmin;
    }

    struct Order {
        uint _orderID;
        address _receiver;
        Status _status;
    }

    struct OrderPayments {
        uint _amount;
        address _customer;
        uint _orderID;
    }

    struct ComponentIncome {
        string _manufacturerName;
        address _manufacturerAddress;
        string _componentName;
        uint _componentTimestampIncome;
    }

    struct FinalProduct {
        string _productName;
        bytes[] _productComponents;

        uint _finalProductTimestamp;
    }

    struct OrderedProducts {
        bytes[] _finalProductUniqueNumbers;
        uint _orderedProductsTimestamp;
    }

    mapping(address => Admin) public admins;

    mapping(uint => Order) public order_info;

    mapping(uint => OrderPayments) public order_payments;

    mapping(bytes32 => ComponentIncome) public component_info;

    mapping(bytes32 => FinalProduct) final_product_info;

    mapping(uint => OrderedProducts) order_with_products;

    event ChangeOrderStatus(uint indexed id, address indexed receiver, Status indexed product_status);
    event PaymentStatus(uint indexed id, address indexed customer, uint indexed orderID);
    event NewComponent(string indexed name, address indexed addressManufacturer, string indexed component, uint timestamp);
    event FinalProductInfo(string indexed product_name, bytes[] indexed components, uint timestamp);

    function component_income(string memory _manufacturer, address _manufacturerAddress, string memory _componentName) public onlyOwner returns (bytes32) {
        bytes32 uinqueComponentNumber = keccak256(abi.encodePacked(_manufacturer, _componentName, block.timestamp));
        component_info[uinqueComponentNumber]._manufacturerName = _manufacturer;
        component_info[uinqueComponentNumber]._manufacturerAddress = _manufacturerAddress;
        component_info[uinqueComponentNumber]._componentName = _componentName;
        component_info[uinqueComponentNumber]._componentTimestampIncome = block.timestamp;
        emit NewComponent(_manufacturer, _manufacturerAddress, _componentName, block.timestamp);
        return uinqueComponentNumber;
    }

    function sendMoneyForComponents(address payable _manufacturerAddress) public payable onlyOwner {
        _manufacturerAddress.transfer(msg.value);
    }

    function final_product(string memory _productName, bytes[] memory _componentUiniqueNumber) public onlyOwner returns (bytes32) {        
        bytes32 uinqueProductNumber = keccak256(abi.encodePacked(_productName, block.timestamp));
        final_product_info[uinqueProductNumber]._productName = _productName;
        final_product_info[uinqueProductNumber]._productComponents = _componentUiniqueNumber;
        final_product_info[uinqueProductNumber]._finalProductTimestamp = block.timestamp;
        emit FinalProductInfo(_productName, _componentUiniqueNumber, block.timestamp);
        return uinqueProductNumber;
    }

    function getFullProductInfo(bytes32 _uinqueProductNumber) public view returns (string memory, bytes[] memory, uint) {
        return (
            final_product_info[_uinqueProductNumber]._productName,
            final_product_info[_uinqueProductNumber]._productComponents, 
            final_product_info[_uinqueProductNumber]._finalProductTimestamp
            );
    }

    function createNewOrder(uint orderID, bytes[] memory _finalProductUniqueNumbers) public onlyOwner {
        order_with_products[orderID]._finalProductUniqueNumbers = _finalProductUniqueNumbers;
        order_with_products[orderID]._orderedProductsTimestamp = block.timestamp;
    }

    function getFullOrderInfoForDeparture(uint orderID) public view onlyOwner returns (uint, bytes[] memory, uint) {
        if (order_with_products[orderID]._orderedProductsTimestamp != 0) {
            return (
                orderID,
                order_with_products[orderID]._finalProductUniqueNumbers,
                order_with_products[orderID]._orderedProductsTimestamp
            );
        } 
        else {
            revert("Such orderID not exists!");
        }
    }

    function inProduction(uint _orderID, address _receiver) public onlyOwner {
        status_choice = Status.In_Production;
        order_info[_orderID]._orderID = _orderID;
        order_info[_orderID]._receiver = _receiver;
        order_info[_orderID]._status = status_choice;
        emit ChangeOrderStatus(_orderID, _receiver, status_choice);
    }

    function paid(uint _orderID, address _receiver) public onlyOwner {
        status_choice = Status.Paid;
        order_info[_orderID]._orderID = _orderID;
        order_info[_orderID]._receiver = _receiver;
        order_info[_orderID]._status = status_choice;

        emit ChangeOrderStatus(_orderID, _receiver, status_choice);
    }

    function inStock(uint _orderID, address _receiver) public onlyOwner {
        status_choice = Status.In_Stock;
        order_info[_orderID]._orderID = _orderID;
        order_info[_orderID]._receiver = _receiver;
        order_info[_orderID]._status = status_choice;

        emit ChangeOrderStatus(_orderID, _receiver, status_choice);
    }

    function delivered(uint _orderID, address _receiver) public onlyOwner {
        status_choice = Status.Delivered;
        order_info[_orderID]._orderID = _orderID;
        order_info[_orderID]._receiver = _receiver;
        order_info[_orderID]._status = status_choice;

        if (_orderID == order_payments[_orderID]._orderID) {
            payable(owner).transfer(order_payments[_orderID]._amount);
        } else {
            revert("Invalid order ID");
        }
        emit ChangeOrderStatus(_orderID, _receiver, status_choice);
    }

    function sent(uint _orderID, address _receiver) public onlyOwner {
        status_choice = Status.Sent;
        order_info[_orderID]._orderID = _orderID;
        order_info[_orderID]._receiver = _receiver;
        order_info[_orderID]._status = status_choice;

        emit ChangeOrderStatus(_orderID, _receiver, status_choice);
    }

    function canceled(uint _orderID, address _receiver) public onlyOwner {
        status_choice = Status.Canceled;
        order_info[_orderID]._orderID = _orderID;
        order_info[_orderID]._receiver = _receiver;
        order_info[_orderID]._status = status_choice;

        emit ChangeOrderStatus(_orderID, _receiver, status_choice);
    }

    function returned(uint _orderID, address _receiver) public onlyOwner {
        status_choice = Status.Returned_To_Warehouse;
        order_info[_orderID]._orderID = _orderID;
        order_info[_orderID]._receiver = _receiver;
        order_info[_orderID]._status = status_choice;

        emit ChangeOrderStatus(_orderID, _receiver, status_choice);
    }

    function sendMoneyForOrder(uint _ID) public payable {
        balanceReceived = msg.value;
        order_payments[_ID]._customer = msg.sender;
        order_payments[_ID]._amount = balanceReceived;
        order_payments[_ID]._orderID = _ID;
        emit PaymentStatus(balanceReceived, msg.sender, _ID);
    }

    function addAdmin(address _newAdmin) public onlyOwner returns (bool) {
        return admins[_newAdmin]._isAdmin = true;
    }
}