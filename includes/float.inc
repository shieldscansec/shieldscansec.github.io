#if defined _float_included
    #endinput
#endif
#define _float_included

#pragma rational Float

/* Float constants */
#define FLOAT_PI            3.1415926535897932384626433832795
#define FLOAT_E             2.7182818284590452353602874713527
#define FLOAT_INFINITY      Float:0x7F800000
#define FLOAT_NEG_INFINITY  Float:0xFF800000
#define FLOAT_NAN           Float:0x7FC00000

/* Float functions */
native Float:float(value);
native Float:floatstr(const string[]);
native Float:floatmul(Float:oper1, Float:oper2);
native Float:floatdiv(Float:dividend, Float:divisor);
native Float:floatadd(Float:oper1, Float:oper2);
native Float:floatsub(Float:oper1, Float:oper2);
native Float:floatfract(Float:value);
native floatround(Float:value, method=0);
native floatcmp(Float:oper1, Float:oper2);

/* Mathematical functions */
native Float:floatsqroot(Float:value);
native Float:floatpower(Float:value, Float:exponent);
native Float:floatlog(Float:value, Float:base=10.0);
native Float:floatsin(Float:value, anglemode=radian);
native Float:floatcos(Float:value, anglemode=radian);
native Float:floattan(Float:value, anglemode=radian);
native Float:floatasin(Float:value, anglemode=radian);
native Float:floatacos(Float:value, anglemode=radian);
native Float:floatatan(Float:value, anglemode=radian);
native Float:floatatan2(Float:y, Float:x, anglemode=radian);
native Float:floatabs(Float:value);

/* Angle mode constants */
#define radian              0
#define degrees             1
#define grades              2

/* Round methods */
#define floatround_round    0
#define floatround_floor    1
#define floatround_ceil     2
#define floatround_tozero   3