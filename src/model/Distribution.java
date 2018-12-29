package model;

public class Distribution {
    private Integer id;
    private String dis_name;
    private Integer outsider_top;
    private Integer outsider_parent;
    private Integer outsider_self;
    private Integer member_top;
    private Integer member_parent;
    private Integer member_self;
    private Integer is_default;
    private Integer status;
    private String memo;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getDis_name() {
        return dis_name;
    }

    public void setDis_name(String dis_name) {
        this.dis_name = dis_name;
    }

    public Integer getOutsider_top() {
        return outsider_top;
    }

    public void setOutsider_top(Integer outsider_top) {
        this.outsider_top = outsider_top;
    }

    public Integer getOutsider_parent() {
        return outsider_parent;
    }

    public void setOutsider_parent(Integer outsider_parent) {
        this.outsider_parent = outsider_parent;
    }

    public Integer getOutsider_self() {
        return outsider_self;
    }

    public void setOutsider_self(Integer outsider_self) {
        this.outsider_self = outsider_self;
    }

    public Integer getMember_top() {
        return member_top;
    }

    public void setMember_top(Integer member_top) {
        this.member_top = member_top;
    }

    public Integer getMember_parent() {
        return member_parent;
    }

    public void setMember_parent(Integer member_parent) {
        this.member_parent = member_parent;
    }

    public Integer getMember_self() {
        return member_self;
    }

    public void setMember_self(Integer member_self) {
        this.member_self = member_self;
    }

    public Integer getIs_default() {
        return is_default;
    }

    public void setIs_default(Integer is_default) {
        this.is_default = is_default;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }
}
