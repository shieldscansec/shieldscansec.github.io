/*
 * sscanf2.inc - Advanced parameter parsing for SA-MP
 * Version: 2.13+
 * Compatible with SA-MP 0.3.7 and open.mp
 */

#if defined _sscanf2_included
    #endinput
#endif
#define _sscanf2_included

// Native declarations
native sscanf(const data[], const format[], SSCANF_:...);
native unformat(const data[], const format[], SSCANF_:...);

// Error codes
#define SSCANF_TRUE                 (1)
#define SSCANF_FALSE                (0)
#define SSCANF_FAIL                 (1)
#define SSCANF_SUCCESS              (0)

// Custom specifiers
#define SSCANF_Option               |
#define SSCANF_NULL                 NULL
#define SSCANF_QUIET                (1)
#define SSCANF_DEBUG                (2)

// Compatibility macros
#define scanf sscanf
#define format_args sscanf_args

// Advanced parsing options
stock SSCANF_Option(playerid, option)
{
    return option;
}

// String delimiter options
stock SSCANF_SetDelimiters(const delimiters[])
{
    return 1;
}

// Case sensitivity options
stock SSCANF_SetCaseSensitive(bool:sensitive)
{
    return 1;
}

// Quiet mode (suppress warnings)
stock SSCANF_SetQuietMode(bool:quiet)
{
    return 1;
}

// Default value handling
stock SSCANF_SetDefaultValues(bool:defaults)
{
    return 1;
}

// Brazilian Portuguese number formatting
stock SSCANF_SetBrazilianFormat(bool:brazilian = true)
{
    return 1;
}

// CPF/CNPJ validation functions
stock IsValidCPF(const cpf[])
{
    new digits[11];
    new len = strlen(cpf);
    new j = 0;
    
    // Extract only digits
    for (new i = 0; i < len && j < 11; i++)
    {
        if (cpf[i] >= '0' && cpf[i] <= '9')
        {
            digits[j] = cpf[i] - '0';
            j++;
        }
    }
    
    if (j != 11) return 0;
    
    // Check for invalid sequences
    new same = 1;
    for (new i = 1; i < 11; i++)
    {
        if (digits[i] != digits[0])
        {
            same = 0;
            break;
        }
    }
    if (same) return 0;
    
    // First verification digit
    new sum = 0;
    for (new i = 0; i < 9; i++)
    {
        sum += digits[i] * (10 - i);
    }
    new rest = sum % 11;
    new dv1 = (rest < 2) ? 0 : (11 - rest);
    
    if (digits[9] != dv1) return 0;
    
    // Second verification digit
    sum = 0;
    for (new i = 0; i < 10; i++)
    {
        sum += digits[i] * (11 - i);
    }
    rest = sum % 11;
    new dv2 = (rest < 2) ? 0 : (11 - rest);
    
    return (digits[10] == dv2);
}

stock IsValidCNPJ(const cnpj[])
{
    new digits[14];
    new len = strlen(cnpj);
    new j = 0;
    
    // Extract only digits
    for (new i = 0; i < len && j < 14; i++)
    {
        if (cnpj[i] >= '0' && cnpj[i] <= '9')
        {
            digits[j] = cnpj[i] - '0';
            j++;
        }
    }
    
    if (j != 14) return 0;
    
    // Check for invalid sequences
    new same = 1;
    for (new i = 1; i < 14; i++)
    {
        if (digits[i] != digits[0])
        {
            same = 0;
            break;
        }
    }
    if (same) return 0;
    
    // First verification digit
    new peso[] = {5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
    new sum = 0;
    for (new i = 0; i < 12; i++)
    {
        sum += digits[i] * peso[i];
    }
    new rest = sum % 11;
    new dv1 = (rest < 2) ? 0 : (11 - rest);
    
    if (digits[12] != dv1) return 0;
    
    // Second verification digit
    new peso2[] = {6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
    sum = 0;
    for (new i = 0; i < 13; i++)
    {
        sum += digits[i] * peso2[i];
    }
    rest = sum % 11;
    new dv2 = (rest < 2) ? 0 : (11 - rest);
    
    return (digits[13] == dv2);
}

// Phone number validation (Brazilian format)
stock IsValidPhoneNumber(const phone[])
{
    new digits[12];
    new len = strlen(phone);
    new j = 0;
    
    // Extract only digits
    for (new i = 0; i < len && j < 12; i++)
    {
        if (phone[i] >= '0' && phone[i] <= '9')
        {
            digits[j] = phone[i] - '0';
            j++;
        }
    }
    
    // Brazilian mobile: 11 digits (with 9) or 10 digits (landline)
    if (j == 11)
    {
        // Mobile with 9th digit
        return (digits[2] == 9);
    }
    else if (j == 10)
    {
        // Landline
        return (digits[2] >= 2 && digits[2] <= 9);
    }
    
    return 0;
}

// Money formatting (Brazilian Real)
stock FormatMoney(money, output[], size = sizeof(output))
{
    if (money < 0)
    {
        format(output, size, "-R$ %s", NumberFormat(-money));
    }
    else
    {
        format(output, size, "R$ %s", NumberFormat(money));
    }
    return 1;
}

stock NumberFormat(number)
{
    new string[32];
    new neg = 0;
    
    if (number < 0)
    {
        neg = 1;
        number = -number;
    }
    
    format(string, sizeof(string), "%d", number);
    
    new len = strlen(string);
    new output[32];
    new pos = 0;
    
    for (new i = 0; i < len; i++)
    {
        if (i && (len - i) % 3 == 0)
        {
            output[pos++] = '.';
        }
        output[pos++] = string[i];
    }
    
    if (neg)
    {
        format(string, sizeof(string), "-%s", output);
    }
    else
    {
        format(string, sizeof(string), "%s", output);
    }
    
    return string;
}

// Date/Time parsing (Brazilian format: DD/MM/YYYY)
stock ParseBrazilianDate(const datestr[], &day, &month, &year)
{
    return sscanf(datestr, "p</>ddd", day, month, year);
}

// CEP validation and formatting
stock IsValidCEP(const cep[])
{
    new digits[8];
    new len = strlen(cep);
    new j = 0;
    
    for (new i = 0; i < len && j < 8; i++)
    {
        if (cep[i] >= '0' && cep[i] <= '9')
        {
            digits[j] = cep[i] - '0';
            j++;
        }
    }
    
    return (j == 8);
}

stock FormatCEP(const cep[], output[], size = sizeof(output))
{
    new clean[9];
    new j = 0;
    
    for (new i = 0, len = strlen(cep); i < len && j < 8; i++)
    {
        if (cep[i] >= '0' && cep[i] <= '9')
        {
            clean[j++] = cep[i];
        }
    }
    
    if (j == 8)
    {
        format(output, size, "%.5s-%.3s", clean, clean[5]);
        return 1;
    }
    
    return 0;
}

// RG validation (Brazilian format)
stock IsValidRG(const rg[])
{
    new len = strlen(rg);
    new digits = 0;
    
    for (new i = 0; i < len; i++)
    {
        if (rg[i] >= '0' && rg[i] <= '9')
        {
            digits++;
        }
    }
    
    return (digits >= 7 && digits <= 9);
}

#endif