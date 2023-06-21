// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SensorContract{
    bool public contractTerminated = false;
    event ContractTerminated(bool terminated);
    
    address payable public transporter;
    address payable public productOwner;
    uint256 public startTime;
    uint256 public endTime;
    uint256 public contractCost = 2 ether;
    bool public contractExpired = false;
    bool public conditionViolated = false;
    uint256 private temperature;
    uint256 private humidity;
    uint256 private pressure;
    uint256 private vibration;
    bool public isContractActive = true;

    constructor(address payable _productOwner) payable {
        require(msg.value == contractCost, "Contract cost must be 2 ether");
        transporter = payable(msg.sender);
        productOwner = _productOwner;
        startTime = block.timestamp;
        endTime = startTime + 48 hours;
    }

    function updateConditions(
        uint256 _temperature,
        uint256 _humidity,
        uint256 _pressure,
        uint256 _vibration
    ) public {
        require(!contractExpired, "Contract has already expired");
        require(msg.sender == transporter, "Only transporter can update conditions");

        temperature = _temperature;
        humidity = _humidity;
        pressure = _pressure;
        vibration = _vibration;

        if (
            (temperature < 9 || temperature > 27) ||
            (pressure < 50000 || pressure > 150000) ||
            (humidity < 5 || humidity > 65)
        ) {
            conditionViolated = true;
            contractTerminated = true; // Sözleşme fesh edildiğini belirtmek için true olarak güncellenir.
            emit ContractTerminated(true); // Sözleşme fesh edildiğini belirten bir olay tetiklenir.
        }

        if (vibration == 1) {
            isContractActive = false;
        }
    }
    function checkContractExpiry() public {
        require(!contractExpired, "Contract has already expired");
        if (block.timestamp >= endTime) {
            contractExpired = true;
            if (conditionViolated) {
                productOwner.transfer(contractCost);
            } else {
                transporter.transfer(contractCost);
            }
        }
    }
    function getTemperature() public view returns (uint256) {
        return temperature;
    }

    function getHumidity() public view returns (uint256) {
        return humidity;
    }

    function getPressure() public view returns (uint256) {
        return pressure;
    }

    function getVibration() public view returns (uint256) {
        return vibration;
    }
}