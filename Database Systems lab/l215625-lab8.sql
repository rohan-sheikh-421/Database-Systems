#Q1
USE OrderSchema;
GO

CREATE TRIGGER trg_PreventDeleteCustomer
ON Customers
INSTEAD OF DELETE
AS
BEGIN
  SET NOCOUNT ON;

  IF EXISTS (SELECT * FROM deleted d INNER JOIN [Order] o ON d.CustomerNo = o.CustomerNo)
  BEGIN
    RAISERROR('This customer cannot be deleted because they have made at least one order.', 16, 1);
  END
  ELSE
  BEGIN
    DELETE FROM Customers WHERE CustomerNo IN (SELECT CustomerNo FROM deleted);
  END
END;

#Q2
DELIMITER //
CREATE TRIGGER order_details_insert_trigger
INSTEAD OF INSERT ON order_details
FOR EACH ROW
BEGIN
    DECLARE available_quantity INT;
    SELECT quantity INTO available_quantity FROM store WHERE product_id = NEW.product_id;
    IF available_quantity < NEW.quantity THEN
        SELECT 'The required quantity is not available';
    ELSE
        INSERT INTO order_details (order_id, product_id, quantity) VALUES (NEW.order_id, NEW.product_id, NEW.quantity);
    END IF;
END //
DELIMITER ;

Q#3
CREATE TRIGGER trg_CheckQuantity
AFTER UPDATE ON OrderDetails
FOR EACH ROW
BEGIN
  DECLARE quantity_in_store INT;

  -- get the current quantity in store
  SELECT quantity INTO quantity_in_store
  FROM Store
  WHERE product_id = NEW.product_id;

  -- check if the updated quantity is greater than the quantity in store
  IF NEW.quantity > quantity_in_store THEN
    -- rollback the update
    ROLLBACK;
    -- print an error message
    SELECT 'The updated quantity is not available in the store';
  END IF;
END;

Q#4
Items (ItemID int PRIMARY KEY, ItemName varchar(50), QuantityInStore int)

CREATE TRIGGER prevent_delete_if_quantity_high
AFTER DELETE
ON Items
FOR EACH ROW
BEGIN
    IF OLD.QuantityInStore > 100 THEN
        RAISE(ABORT, 'Cannot delete item because quantity in store is more than 100')
    END IF;
END;

Q#5
CREATE TRIGGER insert_order_date
INSTEAD OF INSERT ON Orders
FOR EACH ROW
BEGIN
  IF NEW.order_date != CURDATE() THEN
    SET NEW.order_date = CURDATE();
    INSERT INTO Orders (customer_id, order_date) VALUES (NEW.customer_id, NEW.order_date);
  ELSE
    INSERT INTO Orders (customer_id, order_date) VALUES (NEW.customer_id, NEW.order_date);
  END IF;
END;

Q#6
CREATE TRIGGER [dbo].[AfterInsertCustomer] ON [dbo].[Customers]
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM INSERTED WHERE FirstName IS NULL OR LastName IS NULL OR Email IS NULL OR Address IS NULL OR City IS NULL OR State IS NULL OR Zip IS NULL)
    BEGIN
        RAISERROR ('Cannot insert a customer with null fields.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END

Q#7
CREATE PROCEDURE CustomerSignup
    @CustomerNo INT,
    @CustomerName VARCHAR(50),
    @City VARCHAR(50),
    @Phone VARCHAR(10),
    @Flag INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if customer No. is unique
    IF EXISTS (SELECT 1 FROM Customers WHERE CustomerNo = @CustomerNo)
    BEGIN
        SET @Flag = 1;
        RETURN;
    END

    -- Check if phone number is of 6 digits
    IF LEN(@Phone) <> 6
    BEGIN
        SET @Flag = 3;
        RETURN;
    END

    -- Insert the customer
    INSERT INTO Customers (CustomerNo, CustomerName, City, Phone)
    VALUES (@CustomerNo, @CustomerName, @City, @Phone);

    SET @Flag = 0;
    RETURN;
END

#And here is an example of how to execute the procedure and get the flag as output parameter:
DECLARE @Flag INT;

EXEC CustomerSignup 
    @CustomerNo = 12345, 
    @CustomerName = 'John Doe', 
    @City = 'New York', 
    @Phone = '123456', 
    @Flag = @Flag OUTPUT;

SELECT @Flag;