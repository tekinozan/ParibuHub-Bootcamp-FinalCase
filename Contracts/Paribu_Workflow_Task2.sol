// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RentalContract {
    enum PropertyType { House, Shop }
    enum RentalStatus { Rented, NotRented }
    
    struct Tenant {
        address tenantAddress;
        string firstName;
        string lastName;
    }
    
    struct Owner {
        address ownerAddress;
        string firstName;
        string lastName;
    }

    struct Property {
        PropertyType propertyType;
        address ownerAddress;
        string addressLocation;
        uint256 rentalStartDate;
        uint256 rentalEndDate;
        RentalStatus status;
    }
    
    struct Report {
        address tenantAddress;
        PropertyType propertyType;
        string addressLocation;
        string issueDescription;
    }
    
    Tenant[] public tenants;
    Owner[] public owners;
    Property[] public properties;
    Report[] public reports;
    
    event PropertyRented(address ownerAddress, PropertyType propertyType, string addressLocation, uint256 rentalStartDate, uint256 rentalEndDate);
    event RentalTerminated(address ownerAddress, PropertyType propertyType, string addressLocation);
    event ReportSubmitted(address tenantAddress, PropertyType propertyType, string addressLocation, string issueDescription);
    
    mapping(address => bool) public ownerAuthorization;
    mapping(address => bool) public tenantAuthorization;
    
    constructor() {
        ownerAuthorization[msg.sender] = true; // Kontrat oluşturucu başlangıçta sahip olarak eklenir
    }
    
    modifier onlyOwner() {
        require(ownerAuthorization[msg.sender], "Sadece ev veya dükkan sahipleri bu işlemi gerçekleştirebilir.");
        _;
    }
    
    modifier onlyTenant() {
        require(tenantAuthorization[msg.sender], "Sadece kiracılar bu işlemi gerçekleştirebilir.");
        _;
    }
    
    function authorizeOwner(address _ownerAddress) public onlyOwner {
        ownerAuthorization[_ownerAddress] = true;
    }
    
    function revokeOwnerAuthorization(address _ownerAddress) public onlyOwner {
        ownerAuthorization[_ownerAddress] = false;
    }
    
    function authorizeTenant(address _tenantAddress) public onlyOwner {
        tenantAuthorization[_tenantAddress] = true;
    }
    
    function revokeTenantAuthorization(address _tenantAddress) public onlyOwner {
        tenantAuthorization[_tenantAddress] = false;
    }
    
    function addProperty(
        PropertyType _propertyType,
        string memory _addressLocation,
        uint256 _rentalStartDate,
        uint256 _rentalEndDate
    ) public onlyOwner {
        require(_rentalStartDate < _rentalEndDate, "Lütfen geçerli bir kira tarih aralığı sağlayın.");
        Property memory newProperty = Property(_propertyType, msg.sender, _addressLocation, _rentalStartDate, _rentalEndDate, RentalStatus.NotRented);
        properties.push(newProperty);
        emit PropertyRented(msg.sender, _propertyType, _addressLocation, _rentalStartDate, _rentalEndDate);
    }
    
    function rentProperty(PropertyType _propertyType, string memory _addressLocation) public {
        for (uint256 i = 0; i < properties.length; i++) {
            if (properties[i].ownerAddress == msg.sender && properties[i].propertyType == _propertyType && keccak256(abi.encodePacked(properties[i].addressLocation)) == keccak256(abi.encodePacked(_addressLocation)) && properties[i].status == RentalStatus.NotRented) {
                properties[i].status = RentalStatus.Rented;
                tenantAuthorization[msg.sender] = true; // Kiracıyı yetkilendir
                emit PropertyRented(msg.sender, _propertyType, _addressLocation, properties[i].rentalStartDate, properties[i].rentalEndDate);
                break;
            }
        }
    }
    
    function terminateRental(PropertyType _propertyType, string memory _addressLocation) public onlyOwner {
        for (uint256 i = 0; i < properties.length; i++) {
            if (properties[i].ownerAddress == msg.sender && properties[i].propertyType == _propertyType && keccak256(abi.encodePacked(properties[i].addressLocation)) == keccak256(abi.encodePacked(_addressLocation)) && properties[i].status == RentalStatus.Rented) {
                properties[i].status = RentalStatus.NotRented;
                tenantAuthorization[msg.sender] = false; // Kiracının yetkilendirmesini kaldır
                emit RentalTerminated(msg.sender, _propertyType, _addressLocation);
                break;
            }
        }
    }
    
    function reportIssue(PropertyType _propertyType, string memory _addressLocation, string memory _issueDescription) public onlyTenant {
        for (uint256 i = 0; i < properties.length; i++) {
            if (properties[i].propertyType == _propertyType && keccak256(abi.encodePacked(properties[i].addressLocation)) == keccak256(abi.encodePacked(_addressLocation)) && properties[i].status == RentalStatus.Rented) {
                Report memory newReport = Report(msg.sender, _propertyType, _addressLocation, _issueDescription);
                reports.push(newReport);
                emit ReportSubmitted(msg.sender, _propertyType, _addressLocation, _issueDescription);
                break;
            }
        }
    }
}
