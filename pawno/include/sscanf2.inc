/*
 *  sscanf 2.13.8
 *
 *  Version: MPL 1.1
 *
 *  The contents of this file are subject to the Mozilla Public License Version
 *  1.1 (the "License"); you may not use this file except in compliance with
 *  the License. You may obtain a copy of the License at
 *  http://www.mozilla.org/MPL/
 *
 *  Software distributed under the License is distributed on an "AS IS" basis,
 *  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 *  for the specific language governing rights and limitations under the
 *  License.
 *
 *  The Original Code is the sscanf 2.0 SA:MP plugin.
 *
 *  The Initial Developer of the Original Code is Alex "Y_Less" Cole.
 *  Portions created by the Initial Developer are Copyright (c) 2022
 *  the Initial Developer. All Rights Reserved.
 *
 *  Contributor(s):
 *
 *      Cheaterman
 *      DEntisT
 *      Emmet_
 *      karimcambridge
 *      kalacsparty
 *      Kirima
 *      leHeix
 *      maddinat0r
 *      Southclaws
 *      Y_Less
 *      ziggi
 *
 *  Special Thanks to:
 *
 *      SA:MP Team past, present, and future.
 *      maddinat0r, for hosting the repo for a very long time.
 *      Emmet_, for his efforts in maintaining it for almost a year.
 */

#if defined _inc_sscanf
	#endinput
#endif
#define _inc_sscanf

// SSCANF Constants
#define SSCANF_TRUE                 (1)
#define SSCANF_FALSE                (0)

// Native functions
native sscanf(const data[], const format[], {Float,_}:...);
native unformat(const data[], const format[], {Float,_}:...);

// Aliases for compatibility
#define SSCANF:string[%1] s[%1]
#define SSCANF:str        string

// Brazilian validation functions
stock ValidateCPF(const cpf[])
{
    if (strlen(cpf) != 11) return 0;
    for (new i = 0; i < 11; i++)
    {
        if (cpf[i] < '0' || cpf[i] > '9') return 0;
    }
    return 1;
}

stock ValidateCNPJ(const cnpj[])
{
    if (strlen(cnpj) != 14) return 0;
    for (new i = 0; i < 14; i++)
    {
        if (cnpj[i] < '0' || cnpj[i] > '9') return 0;
    }
    return 1;
}

stock ValidateBrazilianPhone(const phone[])
{
    new len = strlen(phone);
    if (len < 10 || len > 11) return 0;
    for (new i = 0; i < len; i++)
    {
        if (phone[i] < '0' || phone[i] > '9') return 0;
    }
    return 1;
}

stock FormatMoney(amount, output[], size = sizeof(output))
{
    new str[32];
    format(str, sizeof(str), "%d", amount);
    
    new len = strlen(str);
    new formatted[32];
    new pos = 0;
    
    for (new i = 0; i < len; i++)
    {
        if (i > 0 && (len - i) % 3 == 0)
        {
            formatted[pos++] = '.';
        }
        formatted[pos++] = str[i];
    }
    
    format(output, size, "R$ %s", formatted);
    return 1;
}

