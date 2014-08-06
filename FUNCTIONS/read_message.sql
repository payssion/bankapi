CREATE OR REPLACE FUNCTION Read_Message(OUT Plaintext text, OUT FromBankID text, OUT ToBankID text, _MessageID text) RETURNS RECORD AS $BODY$
SELECT
    Decrypt_Verify.Plaintext,
    FromBankKey.BankID,
    ToBankKey.BankID
FROM Decrypt_Verify(dearmor(Get_Message($1))), Keys AS FromBankKey, Keys AS ToBankKey
WHERE FromBankKey.MainKeyID = Decrypt_Verify.SignatureKeyID
AND   ToBankKey.SubKeyID    = Decrypt_Verify.EncryptionKeyID
$BODY$ LANGUAGE sql VOLATILE;
