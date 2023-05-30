// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./interfaces/IPremium.sol";

contract Consciousness {
    address payable owner;
    uint256 constant ownerPercentage = 80;
    uint256 constant creatorPercentage = 20;
    uint256 contentId;
    uint256 constant tokenAmount = 0.001 ether;
    IPremium public _premiumContract;

    constructor(address _gameContract) {
        owner = payable(msg.sender);
        _premiumContract = IPremium(_gameContract);
    }

    /// @dev Holds every single content details
    struct Content {
        address payable contentOwner;
        uint256 id;
        bool accepted;
        string imageString;
        string title;
        string contentDescription;
        string category;
        string facebook;
        string instagram;
        string telegram;
        string twitter;
    }

    mapping(uint256 => bool) contentAccepted;
    mapping(address => mapping(uint256 => Content)) contentApproval;
    mapping(address => Content) contentMap;
    Content[] contents;

    /**
     * @dev Propose content to be voted on by the premium members.
     * @param _image Image for the content.
     * @param _title Title of the content.
     * @param _contentDesc Description of the content.
     * @param _category Category of the content.
     */
    function proposeContent(
        string memory _image,
        string memory _title,
        string memory _contentDesc,
        string memory _category,
         string memory _facebook,
        string memory _instagram,
        string memory _telegram,
        string memory _twitter
    ) external {
        Content storage proposed = contentMap[msg.sender];
        proposed.contentOwner = payable(msg.sender);
        proposed.id = contentId;
        proposed.imageString = _image;
        proposed.title = _title;
        proposed.contentDescription = _contentDesc;
        proposed.category = _category;
        proposed.instagram = _instagram;
        proposed.telegram = _telegram;
        proposed.facebook = _facebook;
        proposed.twitter = _twitter;
        contentId++;
        contents.push(proposed);
    }

    modifier onlyWhitelistedAddress() {
        require(
            _premiumContract._whitelistedAddresses(msg.sender),
            "Sender is not whitelisted"
        );
        _;
    }

    /**
     * @dev Vote for a specific content proposed by its owner.
     * @param _contentId ID of the content.
     */
    function voteContent(uint256 _contentId, address _contentOwner) external onlyWhitelistedAddress {
        Content storage content = contentApproval[_contentOwner][_contentId];
        content.accepted = true;
        contentAccepted[_contentId] = true;
    }

    function getAllContent() external view returns (Content[] memory) {
        return contents;
    }

    function checkIfApproved(
        uint256 _contentId
    ) external view returns (bool) {
        return contentAccepted[_contentId];
    }

    function getApprovedContent() external view returns (Content[] memory) {
        uint256 approvedCount = 0;

        for (uint256 i = 0; i < contents.length; i++) {
            if (contents[i].accepted == true) {
                approvedCount++;
            }
        }

        Content[] memory approvedContent = new Content[](approvedCount);
        approvedCount = 0;

        for (uint256 i = 0; i < contents.length; i++) {
            if (contents[i].accepted == true) {
                approvedContent[approvedCount] = contents[i];
                approvedCount++;
            }
        }

        return approvedContent;
    }
}
