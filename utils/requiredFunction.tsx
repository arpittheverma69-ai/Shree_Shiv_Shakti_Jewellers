export const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('en-IN', {
        style: 'currency',
        currency: 'INR',
        minimumFractionDigits: 0,
        maximumFractionDigits: 2,
    }).format(amount);
};
export const formatCurrencyMax3 = (amount: number, max: number | 3) => {
    return new Intl.NumberFormat('en-IN', {
        style: 'currency',
        currency: 'INR',
        minimumFractionDigits: 0,
        maximumFractionDigits: max,
    }).format(amount);
};
export function trimTo3Decimals(num: number) {
    return Math.floor(num * 1000) / 1000;
}