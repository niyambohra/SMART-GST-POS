# SMART GST Mart — Indian GST & Financial Calculations Guide

SMART GST Mart features a dedicated mathematical engine ([`GSTEngine`](file:///Users/niyamdbohra/Desktop/Smart_GST_POS/lib/services/gst_engine.dart)) tailored for the Indian Goods and Services Tax (GST) framework.

---

## 1. Supported GST Slabs

The system supports all standard statutory Indian GST rates:
- **0% (Exempt)**: Unprocessed food grains, milk, fresh vegetables.
- **5%**: Packaged basic foods, standard apparel below ₹1000, edible oils.
- **12%**: Processed food, packaged butter, cheese, computers/tablets.
- **18%**: Electronics, consumer hardware, software services, restaurants.
- **28%**: Luxury goods, automobiles, air conditioners.
- **Custom Slabs**: Configurable by Owner/Admin via Admin Settings.

---

## 2. Tax Computation Rules

### A. Intra-State Sale (Same State)
When the seller's state matches the customer's state (or walk-in customer):
$$\text{CGST} = \text{round}_2\left(\frac{\text{Total GST}}{2}\right)$$
$$\text{SGST} = \text{Total GST} - \text{CGST}$$
$$\text{IGST} = 0.00$$
*(Calculating SGST as the difference prevents 1 paisa rounding drift across items).*

### B. Inter-State Sale (Different State)
When customer's state differs from seller's business registration:
$$\text{IGST} = \text{Total GST}$$
$$\text{CGST} = 0.00$$
$$\text{SGST} = 0.00$$

---

## 3. Step-by-Step Item Calculation Formula

Given:
- Unit Price ($P$)
- Quantity ($Q$)
- Item Discount ($D$)
- GST Rate ($R\%$)

1. **Raw Subtotal**:
   $$\text{Raw} = P \times Q$$
2. **Taxable Amount**:
   $$\text{Taxable} = \text{round}_2(\text{Raw} - D)$$
3. **Total GST Amount**:
   $$\text{Total GST} = \text{round}_2\left(\text{Taxable} \times \frac{R}{100}\right)$$
4. **Line Item Total**:
   $$\text{Line Total} = \text{Taxable} + \text{Total GST}$$

---

## 4. Invoice Level Totals & Cash Round-Off

1. **Net Taxable Subtotal**: $\sum \text{Item Taxable} - \text{Global Discount}$
2. **Total Tax Collected**: $\sum \text{Item GST}$ (re-proportioned if global discount applied)
3. **Raw Total**: $\text{Net Taxable} + \text{Total Tax}$
4. **Grand Total**: $\text{round}(\text{Raw Total})$ (standard rupee rounding)
5. **Round-Off**: $\text{Grand Total} - \text{Raw Total}$
