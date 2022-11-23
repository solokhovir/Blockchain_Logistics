// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

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
        // string _name;
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

    mapping(address => Admin) public admins;
    // Order[] public order_info;
    mapping(uint => Order) public order_info;

    mapping(uint => OrderPayments) public order_payments;

    event ChangeOrderStatus(uint indexed id, address indexed receiver, Status indexed product_status);
    event PaymentStatus(uint indexed id, address indexed customer, uint indexed orderID);

    function in_production(uint _orderID, address _receiver) public onlyOwner {
        status_choice = Status.In_Production;

        order_info[_orderID]._orderID = _orderID;
        order_info[_orderID]._receiver = _receiver;
        order_info[_orderID]._status = status_choice;

        // order_info.push(Order({_orderID: _orderID, _receiver: _receiver, _status: status_choice}));
        emit ChangeOrderStatus(_orderID, _receiver, status_choice);
    }

    function paid(uint _orderID, address _receiver) public onlyOwner {
        status_choice = Status.Paid;
        // order_info.push(Order({_orderID: _orderID, _receiver: _receiver, _status: status_choice}));
        order_info[_orderID]._orderID = _orderID;
        order_info[_orderID]._receiver = _receiver;
        order_info[_orderID]._status = status_choice;

        emit ChangeOrderStatus(_orderID, _receiver, status_choice);
    }

    function in_stock(uint _orderID, address _receiver) public onlyOwner {
        status_choice = Status.In_Stock;
        // order_info.push(Order({_orderID: _orderID, _receiver: _receiver, _status: status_choice}));
        order_info[_orderID]._orderID = _orderID;
        order_info[_orderID]._receiver = _receiver;
        order_info[_orderID]._status = status_choice;

        emit ChangeOrderStatus(_orderID, _receiver, status_choice);
    }

    function delivered(uint _orderID, address _receiver) public onlyOwner {
        status_choice = Status.Delivered;
        // order_info.push(Order({_orderID: _orderID, _receiver: _receiver, _status: status_choice}));
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
        // order_info.push(Order({_orderID: _orderID, _receiver: _receiver, _status: status_choice}));
        order_info[_orderID]._orderID = _orderID;
        order_info[_orderID]._receiver = _receiver;
        order_info[_orderID]._status = status_choice;

        emit ChangeOrderStatus(_orderID, _receiver, status_choice);
    }

    function canceled(uint _orderID, address _receiver) public onlyOwner {
        status_choice = Status.Canceled;
        // order_info.push(Order({_orderID: _orderID, _receiver: _receiver, _status: status_choice}));
        order_info[_orderID]._orderID = _orderID;
        order_info[_orderID]._receiver = _receiver;
        order_info[_orderID]._status = status_choice;

        emit ChangeOrderStatus(_orderID, _receiver, status_choice);
    }

    function returned(uint _orderID, address _receiver) public onlyOwner {
        status_choice = Status.Returned_To_Warehouse;
        // order_info.push(Order({_orderID: _orderID, _receiver: _receiver, _status: status_choice}));
        order_info[_orderID]._orderID = _orderID;
        order_info[_orderID]._receiver = _receiver;
        order_info[_orderID]._status = status_choice;

        emit ChangeOrderStatus(_orderID, _receiver, status_choice);
    }

    function receiveMoney(uint _ID) public payable {
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